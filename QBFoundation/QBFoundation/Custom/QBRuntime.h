//
//  QBRuntime.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/7.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>
#import "QBDefine.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Swizzle

CG_INLINE
NSString *QBTypeString(NSMethodSignature * methodSignature) {
    QBWarcPerformSelectorLeaks(
       NSString *typeString = [methodSignature performSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@String", @"type"])];
       return typeString;
    );
    
}

CG_INLINE BOOL
QBHasOverrideSuperclassMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getInstanceMethod(targetClass, targetSelector);
    if (!method) return NO;
    
    Method methodOfSuperclass = class_getInstanceMethod(class_getSuperclass(targetClass), targetSelector);
    if (!methodOfSuperclass) return YES;
    
    return method != methodOfSuperclass;
}

/**
 *  如果 fromClass 里存在 originSelector，则这个函数会将 fromClass 里的 originSelector 与 toClass 里的 newSelector 交换实现。
 *  如果 fromClass 里不存在 originSelecotr，则这个函数会为 fromClass 增加方法 originSelector，并且该方法会使用 toClass 的 newSelector 方法的实现，而 toClass 的 newSelector 方法的实现则会被替换为空内容
 *  @warning 注意如果 fromClass 里的 originSelector 是继承自父类并且 fromClass 也没有重写这个方法，这会导致实际上被替换的是父类，然后父类及父类的所有子类（也即 fromClass 的兄弟类）也受影响，因此使用时请谨记这一点。因此建议使用 OverrideImplementation 系列的方法去替换，尽量避免使用 ExchangeImplementations。
 *  @param _fromClass 要被替换的 class，不能为空
 *  @param _originSelector 要被替换的 class 的 selector，可为空，为空则相当于为 fromClass 新增这个方法
 *  @param _toClass 要拿这个 class 的方法来替换
 *  @param _newSelector 要拿 toClass 里的这个方法来替换 originSelector
 *  @return 是否成功替换（或增加）
 */
CG_INLINE BOOL
QBExchangeImplementationsInTwoClasses(Class _fromClass, SEL _originSelector, Class _toClass, SEL _newSelector) {
    if (!_fromClass || !_toClass) {
        return NO;
    }
    
    Method oriMethod = class_getInstanceMethod(_fromClass, _originSelector);
    Method newMethod = class_getInstanceMethod(_toClass, _newSelector);
    if (!newMethod) {
        return NO;
    }
    
    BOOL isAddedMethod = class_addMethod(_fromClass, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        // 如果 class_addMethod 成功了，说明之前 fromClass 里并不存在 originSelector，所以要用一个空的方法代替它，以避免 class_replaceMethod 后，后续 toClass 的这个方法被调用时可能会 crash
        IMP oriMethodIMP = method_getImplementation(oriMethod) ?: imp_implementationWithBlock(^(id selfObject) {});
        const char *oriMethodTypeEncoding = method_getTypeEncoding(oriMethod) ?: "v@:";
        class_replaceMethod(_toClass, _newSelector, oriMethodIMP, oriMethodTypeEncoding);
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}

/// 交换同一个 class 里的 originSelector 和 newSelector 的实现，如果原本不存在 originSelector，则相当于给 class 新增一个叫做 originSelector 的方法
CG_INLINE BOOL
QBExchangeImplementations(Class _class, SEL _originSelector, SEL _newSelector) {
    return QBExchangeImplementationsInTwoClasses(_class, _originSelector, _class, _newSelector);
}

/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是一个 block，用于获取 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 */
CG_INLINE BOOL
QBOverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    IMP imp = method_getImplementation(originMethod);
    BOOL hasOverride = QBHasOverrideSuperclassMethod(targetClass, targetSelector);
    
    // 以 block 的方式达到实时获取初始方法的 IMP 的目的，从而避免先 swizzle 了 subclass 的方法，再 swizzle superclass 的方法，会发现前者调用时不会触发后者 swizzle 后的版本的 bug。
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        IMP result = NULL;
        if (hasOverride) {
            result = imp;
        } else {
            // 如果 superclass 里依然没有实现，则会返回一个 objc_msgForward 从而触发消息转发的流程
            // https://github.com/Tencent/QMUI_iOS/issues/776
            Class superclass = class_getSuperclass(targetClass);
            result = class_getMethodImplementation(superclass, targetSelector);
        }
        
        // 这只是一个保底，这里要返回一个空 block 保证非 nil，才能避免用小括号语法调用 block 时 crash
        // 空 block 虽然没有参数列表，但在业务那边被转换成 IMP 后就算传多个参数进来也不会 crash
        if (!result) {
                result = imp_implementationWithBlock(^(id selfObject){
                    NSLog(@"%@ 没有初始实现, %@ \n %@, %@", NSStringFromClass(targetClass), NSStringFromSelector(targetSelector), selfObject, [NSThread callStackSymbols]);
                });
            }
            
            return result;
        };
        
        if (hasOverride) {
            method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)));
        } else {
            const char *typeEncoding = method_getTypeEncoding(originMethod) ?: QBTypeString([targetClass instanceMethodSignatureForSelector:targetSelector]).UTF8String;
            class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)), typeEncoding);
        }
    
    return YES;
}

/**
 *  用 block 重写某个 class 的某个无参数且返回值为 void 的方法，会自动在调用 block 之前先调用该方法原本的实现。
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做，注意该方法必须无参数，返回值为 void
 *  @param implementationBlock targetSelector 的自定义实现，直接将你的实现写进去即可，不需要管 super 的调用。参数 selfObject 代表当前正在调用这个方法的对象，也即 self 指针。
 */
CG_INLINE BOOL
QBExtendImplementationOfVoidMethodWithoutArguments(Class targetClass, SEL targetSelector, void (^implementationBlock)(__kindof NSObject *selfObject)) {
    return QBOverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        void (^block)(__unsafe_unretained __kindof NSObject *selfObject) = ^(__unsafe_unretained __kindof NSObject *selfObject) {
            
            void (*originSelectorIMP)(id, SEL);
            originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
            originSelectorIMP(selfObject, originCMD);
            
            implementationBlock(selfObject);
        };
        #if __has_feature(objc_arc)
        return block;
        #else
        return [block copy];
        #endif
    });
}

#pragma mark - Ivar

CG_INLINE id QBGetObjectIvarValue(id object, Ivar ivar) {
    return object_getIvar(object, ivar);
}

#pragma mark - Selector

/**
 根据给定的 getter selector 获取对应的 setter selector
 @param getter 目标 getter selector
 @return 对应的 setter selector
 */
CG_INLINE SEL
QBSetterWithGetter(SEL getter) {
    NSString *(^capitalizedBlock)(NSString *) = ^NSString *(NSString *str) {
           if (str.length) {
               return [NSString stringWithFormat:@"%@%@", [str substringToIndex:1].uppercaseString, [str substringFromIndex:1]].copy;
           }
           
           return nil;
       };
    
    NSString *getterString = NSStringFromSelector(getter);
    NSMutableString *setterString = [[NSMutableString alloc] initWithString:@"set"];
    [setterString appendString:capitalizedBlock(getterString)];
    [setterString appendString:@":"];
    SEL setter = NSSelectorFromString(setterString);
    return setter;
}

#pragma mark - Mach-O

typedef struct classref *classref_t;

/**
 获取业务项目的所有 class
 @param classes 传入 classref_t 变量的指针，会填充结果到里面，然后可以用下标访问。如果只是为了得到总数，可传入 NULL。
 @return class 的总数
 
 例如：
 
 @code
 classref_t *classes = nil;
 int count = QBGetProjectClassList(&classes);
 Class class = (__bridge Class)classes[0];
 @endcode
 */
FOUNDATION_EXPORT int QBGetProjectClassList(classref_t _Nonnull *_Nonnull* _Nonnull classes);

/// 以高级语言的方式描述一个 objc_property_t 的各种属性，请使用 `+descriptorWithProperty` 生成对象后直接读取对象的各种值。
@interface QBPropertyDescriptor : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) SEL getter;
@property(nonatomic, assign) SEL setter;

@property(nonatomic, assign) BOOL isAtomic;
@property(nonatomic, assign) BOOL isNonatomic;

@property(nonatomic, assign) BOOL isAssign;
@property(nonatomic, assign) BOOL isWeak;
@property(nonatomic, assign) BOOL isStrong;
@property(nonatomic, assign) BOOL isCopy;

@property(nonatomic, assign) BOOL isReadonly;
@property(nonatomic, assign) BOOL isReadwrite;

@property(nonatomic, copy) NSString *type;

+ (instancetype)descriptorWithProperty:(objc_property_t)property;

@end

NS_ASSUME_NONNULL_END
