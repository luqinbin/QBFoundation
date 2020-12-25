//
//  QBDefine.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#ifndef QBDefine_h
#define QBDefine_h

#pragma mark - Macro definition
#define QBWeakSelf typeof(self) __weak weakSelf = self;
#define QBStrongSelf typeof(weakSelf) __strong self = weakSelf;

#define QBSafe(obj) obj ? obj : [NSNull null]

#if __clang__
#define __PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH(__warc) \
do { \
_Pragma("clang diagnostic push") \
_Pragma(__warc)
#define __PRAGMA_NO_EXTRA_ARG_WARNINGS_POP \
_Pragma("clang diagnostic pop") \
} while (0);
#else
#define __PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH
#define __PRAGMA_NO_EXTRA_ARG_WARNINGS_POP
#endif

// 内存泄漏警告
#define QBWarcPerformSelectorLeaks(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

// 未使用变量
#define QBUnusedVariable(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Wunused-variable\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

// 忽略警告
#define QBDeprecatedDeclarations(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

// 不兼容指针类型
#define QBWincompatiblePointerTypes(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Wincompatible-pointer-types\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

// 循环引用
#define QBWarcRetainCycles(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Warc-retain-cycles\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

// 未使用default
#define QBWcoveredSwitchDefault(__stuff) \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_PUSH("clang diagnostic ignored \"-Wcovered-switch-default\"") \
__stuff \
__PRAGMA_NO_EXTRA_ARG_WARNINGS_POP

// 单例
#define QBSINGTON_INTERFACE  + (instancetype)shareInstance; \
\
+ (instancetype)new NS_UNAVAILABLE; \
- (instancetype)init NS_UNAVAILABLE; \
+ (void)destroyInstance;

#define QBSINGTON_INPLEMENT(class) \
\
static class *_shareInstance; \
static dispatch_once_t _onceToken; \
\
+ (instancetype)shareInstance { \
\
if(_shareInstance == nil) {\
_shareInstance = [[class alloc] init]; \
} \
return _shareInstance; \
} \
\
+(instancetype)allocWithZone:(struct _NSZone *)zone { \
\
dispatch_once(&_onceToken, ^{ \
_shareInstance = [super allocWithZone:zone]; \
}); \
\
return _shareInstance; \
\
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _shareInstance; \
} \
\
+ (void)destroyInstance { \
    _onceToken = 0; \
    _shareInstance = nil; \
}

#define QBSERIALIZE_CODER_DECODER()     \
\
- (id)initWithCoder:(NSCoder *)coder {    \
\
    NSLog(@"%s",__func__);  \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {   \
        /*判断是自身类还是父类*/    \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
            \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];   \
            id varValue = [coder decodeObjectForKey:key];   \
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
            if (varValue && [filters containsObject:key] == NO) { \
                [self setValue:varValue forKey:key];    \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
    return self;    \
}   \
\
- (void)encodeWithCoder:(NSCoder *)coder {    \
\
    NSLog(@"%s",__func__);  \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {   \
        /*判断是自身类还是父类*/    \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/ \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
        \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];    \
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
            id varValue = [self valueForKey:key];   \
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
            if (varValue && [filters containsObject:key] == NO) { \
                [coder encodeObject:varValue forKey:key];   \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
}


#define QBCOPY_WITH_ZONE()  \
\
- (id)copyWithZone:(NSZone *)zone {   \
\
    NSLog(@"%s",__func__);  \
    id copy = [[[self class] allocWithZone:zone] init];    \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {  \
        /*判断是自身类还是父类*/    \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
        \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];    \
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
            id varValue = [self valueForKey:key];   \
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
            if (varValue && [filters containsObject:key] == NO) { \
                [copy setValue:varValue forKey:key];    \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
    return copy;    \
}


#define QBDESCRIPTION() \
\
/* 用来打印本类的所有变量(成员变量+属性变量)，所有层级父类的属性变量及其对应的值 */  \
- (NSString *)description {   \
\
    NSString  *despStr = @"";   \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {   \
        /*判断是自身类还是父类*/  \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
        \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];    \
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
            id varValue = [self valueForKey:key];   \
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
            if (varValue && [filters containsObject:key] == NO) { \
                despStr = [despStr stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", key, varValue]]; \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
    return despStr; \
}

#endif /* QBDefine_h */
