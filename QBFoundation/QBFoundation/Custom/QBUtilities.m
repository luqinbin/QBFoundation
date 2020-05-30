//
//  QBUtilities.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "QBUtilities.h"
#import "UIColor+QBExtension.h"

NSString *_Nullable QBClipboardContent(void) {
    @try {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        NSString *clipboardContent = [pasteBoard string];
        if (!clipboardContent || clipboardContent.length <= 0 || [clipboardContent isEqual:[NSNull null]]) {
            return @"";
        }
        return clipboardContent;
    } @catch (NSException *exception) {
        return @"";
    }
}

#pragma mark - keyedArchiver/keyedUnarchiver
BOOL QBObjArchive(_Nonnull id objToBeArchived, NSString *key, NSString *filePath) {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:objToBeArchived forKey:key];
    [archiver finishEncoding];
    
    return [data writeToFile:filePath atomically:YES];
}

id QBObjUnArchive(NSString * _Nonnull key, NSString *filePath) {
    NSMutableData *dedata = [NSMutableData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dedata];
    id objToStoreData = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return objToStoreData;
}

#pragma mark - AppDelegate
id<UIApplicationDelegate> QBApplicationDelegate(void) {
    return (id<UIApplicationDelegate> )[[UIApplication sharedApplication] delegate];
}

#pragma mark - NSUserDefaults
NSUserDefaults *QBUserDefaults(void) {
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - UIImage
UIImage *_Nullable QBImage(NSString *name) {
    return [UIImage imageNamed:name];
}

#pragma mark - UIColor
UIColor *_Nullable QBColorHex(NSString *hexStr) {
    return [UIColor qbColorWithHexString:hexStr];
}

UIColor *_Nullable QBAlphaColorHex(NSString *hexStr, CGFloat alpha) {
    return [UIColor qbColorWithHexString:hexStr alpha:alpha];
}

#pragma mark - UIFont
UIFont *_Nullable QBSystemFont(CGFloat fontSize) {
    return [UIFont systemFontOfSize:fontSize];
}

UIFont *_Nullable QBBoldSystemFont(CGFloat fontSize) {
    return [UIFont boldSystemFontOfSize:fontSize];
}

UIFont *_Nullable QBFontForHelveticaBold(CGFloat fontSize) {
    return [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
}

UIFont *_Nullable QBFontForHelvetica(CGFloat fontSize) {
    return [UIFont fontWithName:@"Helvetica" size:fontSize];
}

#pragma mark - NSNotification
void QBResgiterNotification(id observer, SEL selector,  NSNotificationName _Nullable name) {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:nil];
}

void QBRemoveNotification(id observer, NSNotificationName _Nullable name) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
}

void QBRemoveAllNotification(id observer) {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

void QBPostNotification(NSNotificationName name) {
    QBPostNotificationForObject(name, nil);
}

void QBPostNotificationForObject(NSNotificationName name, _Nullable id anObject) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:anObject];
}

void QBPostNotificationForUserInfo(NSNotificationName name, NSDictionary *_Nullable userInfo) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

#pragma mark - CGRect
CGRect QBCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode) {
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (mode) {
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (mode == UIViewContentModeScaleAspectFit) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        }
            break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        }
            break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        }
            break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        }
            break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        }
            break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        }
            break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        }
            break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        }
            break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        }
            break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        }
            break;
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
        default: {
            rect = rect;
        }
    }
    return rect;
}

#pragma mark - Objective-C Type

BOOL QBObjCTypeEqualObjCType(const char *firstObjCType, const char *secondObjCType) {
    return strcmp(firstObjCType, secondObjCType) == 0;
}

BOOL QBObjCTypeIsChar(const char *objCType) {
    return strcmp(objCType, @encode(char)) == 0;
}

BOOL QBObjCTypeIsInt(const char *objCType) {
    return strcmp(objCType, @encode(int)) == 0;
}

BOOL QBObjCTypeIsShort(const char *objCType) {
    return strcmp(objCType, @encode(short)) == 0;
}

BOOL QBObjCTypeIsLong(const char *objCType) {
    return strcmp(objCType, @encode(long)) == 0;
}

BOOL QBObjCTypeIsLongLong(const char *objCType) {
    return strcmp(objCType, @encode(long long)) == 0;
}

BOOL QBObjCTypeIsSignedInteger(const char *objCType) {
    return QBObjCTypeIsChar(objCType) ||
            QBObjCTypeIsInt(objCType) ||
          QBObjCTypeIsShort(objCType) ||
           QBObjCTypeIsLong(objCType) ||
       QBObjCTypeIsLongLong(objCType);
}

BOOL QBObjCTypeIsUnsignedChar(const char *objCType) {
    return strcmp(objCType, @encode(unsigned char)) == 0;
}

BOOL QBObjCTypeIsUnsignedInt(const char *objCType) {
    return strcmp(objCType, @encode(unsigned int)) == 0;
}

BOOL QBObjCTypeIsUnsignedShort(const char *objCType) {
    return strcmp(objCType, @encode(unsigned short)) == 0;
}

BOOL QBObjCTypeIsUnsignedLong(const char *objCType) {
    return strcmp(objCType, @encode(unsigned long)) == 0;
}

BOOL QBObjCTypeIsUnsignedLongLong(const char *objCType) {
    return strcmp(objCType, @encode(unsigned long long)) == 0;
}

BOOL QBObjCTypeIsUnsignedInteger(const char *objCType) {
    return QBObjCTypeIsUnsignedChar(objCType) ||
            QBObjCTypeIsUnsignedInt(objCType) ||
          QBObjCTypeIsUnsignedShort(objCType) ||
           QBObjCTypeIsUnsignedLong(objCType) ||
       QBObjCTypeIsUnsignedLongLong(objCType);
}

BOOL QBObjCTypeIsInteger(const char *objCType) {
    return QBObjCTypeIsSignedInteger(objCType) || QBObjCTypeIsUnsignedInteger(objCType);
}

BOOL QBObjCTypeIsFloat(const char *objCType) {
    return strcmp(objCType, @encode(float)) == 0;
}

BOOL QBObjCTypeIsDouble(const char *objCType) {
    return strcmp(objCType, @encode(double)) == 0;
}

BOOL QBObjCTypeIsFloatingPoint(const char *objCType) {
    return QBObjCTypeIsFloat(objCType) || QBObjCTypeIsDouble(objCType);
}

BOOL QBObjCTypeIsBoolean(const char *objCType) {
    return strcmp(objCType, @encode(BOOL)) == 0 || strcmp(objCType, @encode(bool)) == 0;
}

BOOL QBObjCTypeIsNumeric(const char *objCType) {
    return QBObjCTypeIsInteger(objCType) || QBObjCTypeIsFloatingPoint(objCType);
}

BOOL QBObjCTypeIsId(const char *objCType) {
    return strcmp(objCType, @encode(id)) == 0;
}

BOOL QBObjCTypeIsObject(const char *objCType) {
    return strcmp(objCType, @encode(id)) == 0 || strcmp(objCType, "@?") == 0;
}

BOOL QBObjCTypeIsCharString(const char *objCType) {
    return strcmp(objCType, @encode(char *)) == 0;
}

BOOL QBObjCTypeIsClass(const char *objCType) {
    return strcmp(objCType, @encode(Class)) == 0;
}

BOOL QBObjCTypeIsSelector(const char *objCType) {
    return strcmp(objCType, @encode(SEL)) == 0;
}

BOOL QBObjCTypeIsBlock(const char *objCType) {
    return strcmp(objCType, "@?") == 0;
}

BOOL QBObjCTypeIsPointerToType(const char *objCType) {
    return *objCType == '^';
}

BOOL QBObjCTypeIsPointerLike(const char *objCType) {
    return QBObjCTypeIsObject(objCType) ||
       QBObjCTypeIsCharString(objCType) ||
            QBObjCTypeIsClass(objCType) ||
         QBObjCTypeIsSelector(objCType) ||
    QBObjCTypeIsPointerToType(objCType);
}

BOOL QBObjCTypeIsUnknown(const char *objCType) {
    return *objCType == '?';
}

NSUInteger QBObjCTypeLength(const char *objCType) {
    NSUInteger typeSize = 0;
    NSGetSizeAndAlignment(objCType, &typeSize, NULL);
    return typeSize;
}

#pragma mark - SEL
NSUInteger QBSelectorParameterCount(SEL selector) {
    NSString *selectorString = NSStringFromSelector(selector);
    NSUInteger parameterCount = 0;
    
    for (NSUInteger i = 0; i < selectorString.length; ++i) {
        if ([selectorString characterAtIndex:i] == ':')
            ++parameterCount;
    }
    
    return parameterCount;
}

#pragma mark - CAGravity <==>UIViewContentMode
UIViewContentMode QBCAGravityToUIViewContentMode(NSString *gravity) {
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{ kCAGravityCenter:@(UIViewContentModeCenter),
                 kCAGravityTop:@(UIViewContentModeTop),
                 kCAGravityBottom:@(UIViewContentModeBottom),
                 kCAGravityLeft:@(UIViewContentModeLeft),
                 kCAGravityRight:@(UIViewContentModeRight),
                 kCAGravityTopLeft:@(UIViewContentModeTopLeft),
                 kCAGravityTopRight:@(UIViewContentModeTopRight),
                 kCAGravityBottomLeft:@(UIViewContentModeBottomLeft),
                 kCAGravityBottomRight:@(UIViewContentModeBottomRight),
                 kCAGravityResize:@(UIViewContentModeScaleToFill),
                 kCAGravityResizeAspect:@(UIViewContentModeScaleAspectFit),
                 kCAGravityResizeAspectFill:@(UIViewContentModeScaleAspectFill) };
    });
    if (!gravity)
        return UIViewContentModeScaleToFill;
    return (UIViewContentMode)((NSNumber *)dic[gravity]).integerValue;
}

NSString *QBUIViewContentModeToCAGravity(UIViewContentMode contentMode) {
    switch (contentMode) {
        case UIViewContentModeScaleToFill: return kCAGravityResize;
        case UIViewContentModeScaleAspectFit: return kCAGravityResizeAspect;
        case UIViewContentModeScaleAspectFill: return kCAGravityResizeAspectFill;
        case UIViewContentModeRedraw: return kCAGravityResize;
        case UIViewContentModeCenter: return kCAGravityCenter;
        case UIViewContentModeTop: return kCAGravityTop;
        case UIViewContentModeBottom: return kCAGravityBottom;
        case UIViewContentModeLeft: return kCAGravityLeft;
        case UIViewContentModeRight: return kCAGravityRight;
        case UIViewContentModeTopLeft: return kCAGravityTopLeft;
        case UIViewContentModeTopRight: return kCAGravityTopRight;
        case UIViewContentModeBottomLeft: return kCAGravityBottomLeft;
        case UIViewContentModeBottomRight: return kCAGravityBottomRight;
        default: return kCAGravityResize;
    }
}

