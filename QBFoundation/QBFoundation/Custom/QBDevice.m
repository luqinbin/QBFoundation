//
//  QBDevice.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/3.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "QBDevice.h"
#import <AdSupport/AdSupport.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

// sysctl
#import <sys/sysctl.h>
// utsname
#import <sys/utsname.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <net/if_dl.h>

// mach
#include <mach/mach.h>
#import <mach/machine.h>
#import <mach/vm_statistics.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach-o/arch.h>

// CoreTelephony
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "UIWindow+QBExtension.h"

@implementation QBDevice

+ (NSString *)advertisingIdentifier {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *)IPAddress {
    NSString *address = @"";
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface->ifa_flags & IFF_UP)) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                if ([name isEqualToString:@"en0"]) { // wifi
                    if (addr->sin_family == AF_INET) {
                        if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                            address = [NSString stringWithUTF8String:addrBuf];
                        }
                    } else {
                        const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                        if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                            address = [NSString stringWithUTF8String:addrBuf];
                        }
                    }
                } else if ([name isEqualToString:@"pdp_ip0"]) { // cell
                    if (addr->sin_family == AF_INET) {
                        if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                            address = [NSString stringWithUTF8String:addrBuf];
                        }
                    } else {
                        const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                        if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                            address = [NSString stringWithUTF8String:addrBuf];
                        }
                    }
                } else if ([name isEqualToString:@"en1"]) { //tvOS
                    if (addr->sin_family == AF_INET) {
                        if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                            address = [NSString stringWithUTF8String:addrBuf];
                        }
                    } else {
                        const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                        if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                            address = [NSString stringWithUTF8String:addrBuf];
                        }
                    }
                }
            }
        }
        freeifaddrs(interfaces);
    }
    return address;
}

+ (NSString *)macAdrress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return @"";
    }
    
    if ((buf = malloc(len)) == NULL) {
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

// 硬件信息
#pragma mark - Hardware Information
+ (NSString *)hardwareMachine {
    static NSString *machine = @"";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    });
    return machine;
}

+ (NSString *)OSType {
    static NSString *type = @"";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        type = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    });
    return type;
}

+ (NSString *)OSKernelInfo {
    static NSString *kernelInfo = @"";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        kernelInfo = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    });
    return kernelInfo;
}

+ (NSString *)endianness {
    const NXArchInfo *info = NXGetLocalArchInfo();
    if (info == NULL) {
        return @"Unknown";
    }
    if (info->byteorder == NX_BigEndian) {
        return @"BigEndian";
    } else if (info->byteorder == NX_LittleEndian) {
        return @"LittleEndian";
    }
    return @"Unknown";
}

+ (QBDeviceFamily)deviceFamily {
    NSString *machine = [self hardwareMachine];
    if ([machine hasPrefix:@"iPhone"]) {
        return QBDeviceFamilyiPhone;
    } else if ([machine hasPrefix:@"iPod"]) {
        return QBDeviceFamilyiPod;
    } else if ([machine hasPrefix:@"iPad"]) {
        return QBDeviceFamilyiPad;
    } else if ([machine hasPrefix:@"AppleTV"]) {
        return QBDeviceFamilyAppleTV;
    } else if ([machine hasPrefix:@"Watch"]) {
        return QBDeviceFamilyWatch;
    } else if ([machine hasPrefix:@"i386"] || [machine hasPrefix:@"x86_64"]) {
        return QBDeviceFamilySimulator;
    }
    
    return QBDeviceFamilyUnknow;
}

+ (NSString *)mobileModel {
    // https://www.theiphonewiki.com/wiki/Models
    NSString *machine = [self hardwareMachine];
    if ([machine isEqualToString:@"iPhone1,1"]) {
        return @"iPhone 1G";
    } else if ([machine isEqualToString:@"iPhone1,2"]) {
        return @"iPhone 3G";
    } else if ([machine isEqualToString:@"iPhone2,1"]) {
        return @"iPhone 3GS";
    } else if ([machine isEqualToString:@"iPhone3,1"] ||
               [machine isEqualToString:@"iPhone3,3"]) {
        return @"iPhone 4";
    } else if ([machine isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S";
    } else if ([machine isEqualToString:@"iPhone5,1"] ||
               [machine isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5 (GSM)";
    } else if ([machine isEqualToString:@"iPhone5,3"] ||
               [machine isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5c";
    } else if ([machine isEqualToString:@"iPhone6,1"] ||
               [machine isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5s";
    } else if ([machine isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    } else if ([machine isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6";
    } else if ([machine isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s";
    } else if ([machine isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6S Plus";
    } else if ([machine isEqualToString:@"iPhone8,4"]) {
        return @"iPhone SE";
    } else if ([machine isEqualToString:@"iPhone9,1"] ||
               [machine isEqualToString:@"iPhone9,3"]) {
        return @"iPhone 7";
    } else if ([machine isEqualToString:@"iPhone9,2"] ||
               [machine isEqualToString:@"iPhone9,4"]) {
        return @"iPhone 7 Plus";
    } else if ([machine isEqualToString:@"iPhone10,1"] ||
               [machine isEqualToString:@"iPhone10,4"]) {
        return @"iPhone 8";
    } else if ([machine isEqualToString:@"iPhone10,2"] ||
               [machine isEqualToString:@"iPhone10,5"]) {
        return @"iPhone 8 Plus";
    } else if ([machine isEqualToString:@"iPhone10,3"] ||
               [machine isEqualToString:@"iPhone10,6"]) {
        return @"iPhone X";
    } else if ([machine isEqualToString:@"iPhone11,2"]) {
        return @"iPhone XS";
    } else if ([machine isEqualToString:@"iPhone11,4"] ||
               [machine isEqualToString:@"iPhone11,6"]) {
        return @"iPhone XS Max";
    } else if ([machine isEqualToString:@"iPhone11,8"]) {
        return @"iPhone XR";
    } else if ([machine isEqualToString:@"iPhone12,1"]) {
        return @"iPhone 11";
    } else if ([machine isEqualToString:@"iPhone12,3"]) {
        return @"iPhone 11 Pro";
    } else if ([machine isEqualToString:@"iPhone12,5"]) {
        return @"iPhone 11 Pro Max";
    } else if ([machine isEqualToString:@"iPhone12,8"]) {
        return @"iPhone SE (2rd generation)";
    } else if ([machine isEqualToString:@"iPhone13,1"]) {
        return @"iPhone 12 mini";
    } else if ([machine isEqualToString:@"iPhone13,2"]) {
        return @"iPhone 12";
    } else if ([machine isEqualToString:@"iPhone13,3"]) {
        return @"iPhone 12 Pro";
    } else if ([machine isEqualToString:@"iPhone13,4"]) {
        return @"iPhone 12 Pro Max";
    } else if ([machine isEqualToString:@"iPod1,1"]) {
        return @"iPod Touch";
    } else if ([machine isEqualToString:@"iPod2,1"]) {
        return @"iPod Touch 2";
    } else if ([machine isEqualToString:@"iPod3,1"]) {
        return @"iPod Touch 3";
    } else if ([machine isEqualToString:@"iPod4,1"]) {
        return @"iPod Touch 4";
    } else if ([machine isEqualToString:@"iPod5,1"]) {
        return @"iPod Touch 5";
    } else if ([machine isEqualToString:@"iPod7,1"]) {
        return @"iPod Touch 6G";
    } else if ([machine isEqualToString:@"iPad1,1"]) {
        return @"iPad";
    } else if ([machine isEqualToString:@"iPad2,1"] ||
               [machine isEqualToString:@"iPad2,2"] ||
               [machine isEqualToString:@"iPad2,3"] ||
               [machine isEqualToString:@"iPad2,4"]) {
        return @"iPad 2";
    } else if ([machine isEqualToString:@"iPad2,5"] ||
               [machine isEqualToString:@"iPad2,6"] ||
               [machine isEqualToString:@"iPad2,7"]) {
        return @"iPad Mini";
    } else if ([machine isEqualToString:@"iPad3,1"] ||
               [machine isEqualToString:@"iPad3,2"] ||
               [machine isEqualToString:@"iPad3,3"]) {
        return @"iPad 3";
    } else if ([machine isEqualToString:@"iPad3,4"] ||
               [machine isEqualToString:@"iPad3,5"] ||
               [machine isEqualToString:@"iPad3,6"]) {
        return @"iPad 4";
    } else if ([machine isEqualToString:@"iPad4,1"] ||
               [machine isEqualToString:@"iPad4,2"] ||
               [machine isEqualToString:@"iPad4,3"]) {
        return @"iPad Air";
    } else if ([machine isEqualToString:@"iPad4,4"] ||
               [machine isEqualToString:@"iPad4,5"] ||
               [machine isEqualToString:@"iPad4,6"]) {
        return @"iPad Mini 2";
    } else if ([machine isEqualToString:@"iPad4,7"] ||
               [machine isEqualToString:@"iPad4,8"] ||
               [machine isEqualToString:@"iPad4,9"]) {
        return @"iPad Mini 3";
    } else if ([machine isEqualToString:@"iPad5,1"] ||
               [machine isEqualToString:@"iPad5,2"]) {
        return @"iPad Mini 4";
    } else if ([machine isEqualToString:@"iPad11,1"] ||
               [machine isEqualToString:@"iPad11,2"]) {
        return @"iPad Mini (5th generation)";
    } else if ([machine isEqualToString:@"iPad5,3"] ||
               [machine isEqualToString:@"iPad5,4"]) {
        return @"iPad Air 2";
    } else if ([machine isEqualToString:@"iPad6,3"] ||
               [machine isEqualToString:@"iPad6,4"]) {
        return @"iPad Pro 9.7 inch";
    } else if ([machine isEqualToString:@"iPad6,7"] ||
               [machine isEqualToString:@"iPad6,8"]) {
        return @"iPad Pro 12.9 inch";
    } else if ([machine isEqualToString:@"iPad6,11"] ||
               [machine isEqualToString:@"iPad6,12"]) {
        return @"iPad 5";
    } else if ([machine isEqualToString:@"iPad7,1"] ||
               [machine isEqualToString:@"iPad7,2"]) {
        return @"iPad Pro 12.9-inch 2";
    } else if ([machine isEqualToString:@"iPad7,3"] ||
               [machine isEqualToString:@"iPad7,4"]) {
        return @"iPad Pro 10.5-inch";
    } else if ([machine isEqualToString:@"iPad7,5"] ||
               [machine isEqualToString:@"iPad7,6"]) {
        return @"iPad 6";
    } else if ([machine isEqualToString:@"iPad8,1"] ||
               [machine isEqualToString:@"iPad8,2"] ||
               [machine isEqualToString:@"iPad8,3"] ||
               [machine isEqualToString:@"iPad8,4"]) {
        return @"iPad Pro 11-inch";
    } else if ([machine isEqualToString:@"iPad8,9"] ||
               [machine isEqualToString:@"iPad8,10"]) {
        return @"iPad Pro 11-inch 2";
    } else if ([machine isEqualToString:@"iPad8,5"] ||
               [machine isEqualToString:@"iPad8,6"] ||
               [machine isEqualToString:@"iPad8,7"] ||
               [machine isEqualToString:@"iPad8,8"]) {
        return @"iPad Pro 12.9-inch 3";
    } else if ([machine isEqualToString:@"iPad8,11"] ||
               [machine isEqualToString:@"iPad8,12"]) {
        return @"iPad Pro 12.9-inch 4";
    } else if ([machine isEqualToString:@"iPad11,3"] ||
               [machine isEqualToString:@"iPad11,4"]) {
        return @"iPad Air (3rd generation)";
    } else if ([machine isEqualToString:@"iPad13,1"] ||
               [machine isEqualToString:@"iPad13,2"]) {
        return @"iPad Air (4rd generation)";
    } else if ([machine isEqualToString:@"AirPods1,1"]) {
        return @"AirPods";
    } else if ([machine isEqualToString:@"AppleTV2,1"]) {
        return @"Apple TV 2";
    } else if ([machine isEqualToString:@"AppleTV3,1"] ||
               [machine isEqualToString:@"AppleTV3,2"]) {
        return @"Apple TV 3";
    } else if ([machine isEqualToString:@"AppleTV5,3"]) {
        return @"Apple TV 4";
    } else if ([machine isEqualToString:@"AppleTV6,2"]) {
        return @"Apple TV 4K";
    } else if ([machine isEqualToString:@"Watch1,1"] ||
               [machine isEqualToString:@"Watch1,2"]) {
        return @"Apple Watch 1st";
    } else if ([machine isEqualToString:@"Watch2,3"] ||
               [machine isEqualToString:@"Watch2,4"]) {
        return @"Apple Watch Series 2";
    } else if ([machine isEqualToString:@"Watch2,6"] ||
        [machine isEqualToString:@"Watch2,7"]) {
        return @"Apple Watch Series 1";
    } else if ([machine isEqualToString:@"Watch3,1"] ||
               [machine isEqualToString:@"Watch3,2"] ||
               [machine isEqualToString:@"Watch3,3"] ||
               [machine isEqualToString:@"Watch3,4"]) {
        return @"Apple Watch Series 3";
    } else if ([machine isEqualToString:@"Watch4,1"] ||
               [machine isEqualToString:@"Watch4,2"] ||
               [machine isEqualToString:@"Watch4,3"] ||
               [machine isEqualToString:@"Watch4,4"]) {
        return @"Apple Watch Series 4";
    } else if ([machine isEqualToString:@"Watch5,1"] ||
               [machine isEqualToString:@"Watch5,2"] ||
               [machine isEqualToString:@"Watch5,3"] ||
               [machine isEqualToString:@"Watch5,4"]) {
        return @"Apple Watch Series 5";
    } else if ([machine isEqualToString:@"Watch5,9"] ||
               [machine isEqualToString:@"Watch5,10"] ||
               [machine isEqualToString:@"Watch5,11"] ||
               [machine isEqualToString:@"Watch5,12"]) {
        return @"Apple Watch SE";
    } else if ([machine isEqualToString:@"Watch6,1"] ||
               [machine isEqualToString:@"Watch6,2"] ||
               [machine isEqualToString:@"Watch6,3"] ||
               [machine isEqualToString:@"Watch6,4"]) {
        return @"Apple Watch Series 6";
    } else if ([machine isEqualToString:@"i386"] ||
               [machine isEqualToString:@"x86_64"]) {
        return @"Simulator";
    }
    
    return machine;
}

+ (NSString *)systemUptime {
    NSNumber *days, *hours, *minutes;
    
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSTimeInterval uptimeInterval = [processInfo systemUptime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - uptimeInterval)];
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date toDate:[NSDate date]  options:0];
    
    days = [NSNumber numberWithLong:[components day]];
    hours = [NSNumber numberWithLong:[components hour]];
    minutes = [NSNumber numberWithLong:[components minute]];
    
    NSString *uptime = [NSString stringWithFormat:@"%@ %@ %@",
                        [days stringValue],
                        [hours stringValue],
                        [minutes stringValue]];
    
    if (!uptime) {
        return @"";
    }
    return uptime;
}

+ (NSTimeInterval)bootUptime {
    @try {
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        NSTimeInterval uptimeInterval = [processInfo systemUptime];
        NSDate *currentDate = [NSDate date];
        NSDate *startDate = [currentDate dateByAddingTimeInterval:(- uptimeInterval)];
        return [startDate timeIntervalSince1970];
    } @catch (NSException *exception) {
        return -1;
    }
}

+ (NSString *)qbModel {
    return [[UIDevice currentDevice] model];
}

+ (NSString *)identifierForVendor {
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (uuid.length == 0) {
        uuid = @"";
    }
    return uuid;
}

+ (NSString *)localizedModel {
    return [[UIDevice currentDevice] localizedModel];
}

+ (NSString *)name {
    return [[UIDevice currentDevice] name];
}

+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)systemName {
    return [[UIDevice currentDevice] systemName];
}

+ (CGFloat)screenWidth {
    CGSize size = [UIScreen mainScreen].bounds.size;
    return MIN(size.width, size.height);
}

+ (CGFloat)screenHeight {
    CGSize size = [UIScreen mainScreen].bounds.size;
    return MAX(size.width, size.height);
}

+ (CGFloat)statusBarHeight {
    @try {
        if (@available(iOS 13.0, *)) {
            UIWindow *window = [[UIWindow getLevelNormalWindow] objectAtIndex:0];
            UIStatusBarManager *statusBarManager = window.windowScene.statusBarManager;
            
            return CGRectGetHeight(statusBarManager.statusBarFrame);
        } else {
            return CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        }
    } @catch (NSException *exception) {
        return 0.0f;
    }
}

+ (CGFloat)tabbarHeight {
    if ([self isiPhoneXSeries]) {
        return 83.f;
    } else {
        return 49.f;
    }
}

+ (CGFloat)tabbarSafeBottomMargin {
    if ([self isiPhoneXSeries]) {
        return 34.f;
    } else {
        return 0.f;
    }
}

+ (CGFloat)statusBarAndNavigationBarHeight {
    if ([self isiPhoneXSeries]) {
        return 88.f;
    } else {
        return 64.f;
    }
}

+ (CGFloat)screenBrightness {
    @try {
        CGFloat brightness = [UIScreen mainScreen].brightness;
        if (brightness < 0.0 || brightness > 1.0) {
            return -1;
        }
        
        return (brightness * 100);
    } @catch (NSException *exception) {
        return -1;
    }
}

+ (BOOL)isiPhone {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isiPhone4 {
    NSString *platform = [self hardwareMachine];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(480, 320)));
    }
    return [platform isEqualToString:@"iPhone3,1"] ||
           [platform isEqualToString:@"iPhone3,3"] ||
           [platform isEqualToString:@"iPhone4,1"];
}

+ (BOOL)isiPhone5 {
    NSString *platform = [self hardwareMachine];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(568, 320)));
    }
    return [platform isEqualToString:@"iPhone5,1"] ||
           [platform isEqualToString:@"iPhone5,2"] ||
           [platform isEqualToString:@"iPhone5,3"] ||
           [platform isEqualToString:@"iPhone5,4"] ||
           [platform isEqualToString:@"iPhone6,1"] ||
           [platform isEqualToString:@"iPhone6,2"];
}

+ (BOOL)isiPhone6Series {
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
            (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(667, 375))));
}

+ (BOOL)isiPhone6PlusSeries {
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
            (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(736, 414))));
}

+ (BOOL)isiPhoneXSeries {
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
            (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896, 414)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(390, 844)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(844, 390)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(360, 780)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(780, 360)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(428, 926)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(926, 428))));
}

// 运营商信息
#pragma mark - Carrier Information
+ (NSArray<NSNumber *> *)getOperatorsType{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    NSMutableArray *operatorsTypes = [NSMutableArray arrayWithCapacity:2];
    CTCarrier *carrier = nil;
    
    void (^block)(CTCarrier *) = ^(CTCarrier *carrier) {
        NSString *currentCountryCode = [carrier mobileCountryCode];
        NSString *mobileNetWorkCode = [carrier mobileNetworkCode];
        
        if (![currentCountryCode isEqualToString:@"460"]) {
            [operatorsTypes addObject:@(SSOperatorsTypeUnknown)];
        }
        
        // 参考 https://en.wikipedia.org/wiki/Mobile_country_code
        if ([mobileNetWorkCode isEqualToString:@"00"] ||
            [mobileNetWorkCode isEqualToString:@"02"] ||
            [mobileNetWorkCode isEqualToString:@"07"]) {
            // 中国移动
            [operatorsTypes addObject:@(SSOperatorsTypeChinaMobile)];
        } else if ([mobileNetWorkCode isEqualToString:@"01"] ||
            [mobileNetWorkCode isEqualToString:@"06"] ||
            [mobileNetWorkCode isEqualToString:@"09"]) {
            // 中国联通
            [operatorsTypes addObject:@(SSOperatorsTypeChinaUnicom)];
        } else if ([mobileNetWorkCode isEqualToString:@"03"] ||
            [mobileNetWorkCode isEqualToString:@"05"] ||
            [mobileNetWorkCode isEqualToString:@"11"]) {
            // 中国电信
            [operatorsTypes addObject:@(SSOperatorsTypeTelecom)];
        } else if ([mobileNetWorkCode isEqualToString:@"20"]) {
            // 中国铁通
            [operatorsTypes addObject:@(SSOperatorsTypeChinaTietong)];
        } else {
            [operatorsTypes addObject:@(SSOperatorsTypeUnknown)];
        }
    };
    
    if (@available(iOS 12.0, *)) {
        NSDictionary *carrierDic = telephonyInfo.serviceSubscriberCellularProviders;
        [carrierDic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CTCarrier *carrier = obj;
            block(carrier);
        }];
    } else {
        carrier = [telephonyInfo subscriberCellularProvider];
        block(carrier);
    }
    
    return operatorsTypes;
}

+ (NSArray<NSString *> *)carrierName {
    @try {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSMutableArray *carrierNames = [NSMutableArray arrayWithCapacity:2];
        
        if (@available(iOS 12.0, *)) {
            NSDictionary *carrierDic = networkInfo.serviceSubscriberCellularProviders;
            [carrierDic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CTCarrier *carrier = obj;
                [carrierNames addObject:carrier.carrierName];
            }];
        } else {
            NSString *carrierName = networkInfo.subscriberCellularProvider.carrierName;
            if (!carrierName || carrierName.length <= 0 || [carrierName isEqual:[NSNull null]]) {
                [carrierNames addObject:carrierName];
            }
        }
        
        return carrierNames;
    } @catch (NSException *exception) {
        return @[];
    }
}

+ (NSArray<NSString *> *)carrierMobileCountryCode {
    @try {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSMutableArray *mobileCountryCodes = [NSMutableArray arrayWithCapacity:2];
        
        if (@available(iOS 12.0, *)) {
            NSDictionary *carrierDic = networkInfo.serviceSubscriberCellularProviders;
            [carrierDic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CTCarrier *carrier = obj;
                [mobileCountryCodes addObject:carrier.mobileCountryCode];
            }];
        } else {
            NSString *mobileCountryCode = networkInfo.subscriberCellularProvider.mobileCountryCode;
            if (!mobileCountryCode || mobileCountryCode.length <= 0 || [mobileCountryCode isEqual:[NSNull null]]) {
                [mobileCountryCodes addObject:mobileCountryCode];
            }
        }
        
        return mobileCountryCodes;
    } @catch (NSException *exception) {
        return @[];
    }
}

+ (NSArray<NSString *> *)carrierMobileNetworkCode {
    @try {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSMutableArray *mobileNetworkCodes = [NSMutableArray arrayWithCapacity:2];
        
        if (@available(iOS 12.0, *)) {
            NSDictionary *carrierDic = networkInfo.serviceSubscriberCellularProviders;
            [carrierDic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CTCarrier *carrier = obj;
                [mobileNetworkCodes addObject:carrier.mobileNetworkCode];
            }];
        } else {
            NSString *mobileNetworkCode = networkInfo.subscriberCellularProvider.mobileNetworkCode;
            if (!mobileNetworkCode || mobileNetworkCode.length <= 0 || [mobileNetworkCode isEqual:[NSNull null]]) {
                [mobileNetworkCodes addObject:mobileNetworkCode];
            }
        }
        
        return mobileNetworkCodes;
    } @catch (NSException *exception) {
        return @[];
    }
}

+ (NSArray<NSString *> *)carrierSIMCompany {
    @try {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSMutableArray *mobileCountryCodes = [NSMutableArray arrayWithCapacity:2];
        
        if (@available(iOS 12.0, *)) {
            NSDictionary *carrierDic = networkInfo.serviceSubscriberCellularProviders;
            [carrierDic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CTCarrier *carrier = obj;
                if (carrier.mobileCountryCode && carrier.mobileNetworkCode) {
                    NSString *string = [NSString stringWithFormat:@"%@%@",carrier.mobileCountryCode,carrier.mobileNetworkCode];
                    [mobileCountryCodes addObject:string];
                }
            }];
        } else {
            CTCarrier *carrier = networkInfo.subscriberCellularProvider;
            if (carrier.mobileCountryCode && carrier.mobileNetworkCode) {
                NSString *string = [NSString stringWithFormat:@"%@%@",carrier.mobileCountryCode,carrier.mobileNetworkCode];
                [mobileCountryCodes addObject:string];
            }
        }
        
        return mobileCountryCodes;
    } @catch (NSException *exception) {
        return @[];
    }
}

+ (NSArray<NSString *> *)carrierISOCountryCode {
    @try {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSMutableArray *isoCountryCodes = [NSMutableArray arrayWithCapacity:2];
        
        if (@available(iOS 12.0, *)) {
            NSDictionary *carrierDic = networkInfo.serviceSubscriberCellularProviders;
            [carrierDic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CTCarrier *carrier = obj;
                [isoCountryCodes addObject:carrier.isoCountryCode];
            }];
        } else {
            NSString *isoCountryCode = networkInfo.subscriberCellularProvider.isoCountryCode;
            if (!isoCountryCode || isoCountryCode.length <= 0 || [isoCountryCode isEqual:[NSNull null]]) {
                [isoCountryCodes addObject:isoCountryCode];
            }
        }
        
        return isoCountryCodes;
    } @catch (NSException *exception) {
        return @[];
    }
}

+ (NSArray<NSNumber *> *)carrierAllowsVOIP {
    @try {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSMutableArray *allowsVOIPs = [NSMutableArray arrayWithCapacity:2];
        
        if (@available(iOS 12.0, *)) {
            NSDictionary *carrierDic = networkInfo.serviceSubscriberCellularProviders;
            [carrierDic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CTCarrier *carrier = obj;
                [allowsVOIPs addObject:@(carrier.allowsVOIP)];
            }];
        } else {
            NSNumber *allowsVOIP = @(networkInfo.subscriberCellularProvider.allowsVOIP);
            [allowsVOIPs addObject:allowsVOIP];
        }
        
        return allowsVOIPs;
    } @catch (NSException *exception) {
        return @[];
    }
}

+ (BOOL)isAirPlaneMode {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    if (@available(iOS 12.0, *)) {
        return (BOOL)(!networkInfo.serviceCurrentRadioAccessTechnology);
    } else {
        return (BOOL)(!networkInfo.currentRadioAccessTechnology);
    }
}

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
+ (BOOL)canMakePhoneCalls {
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    
    return can;
}
#endif

#pragma mark - WiFi Information
+ (BOOL)isWiFiEnabled {
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithCapacity:2];
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        for (struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ((interface->ifa_flags & IFF_UP) == IFF_UP) {
                [countedSet addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    NSString *const wifiInterfaceName = @"awd10";
    return [countedSet countForObject:wifiInterfaceName] > 1 ? YES : NO;
}

+ (NSString *)connectingWIFIName {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return @"";
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    if (!info) {
        return @"";
    }
    return [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
}

+ (NSString *)connectingWIFIAddress {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return @"";
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    if (!info) {
        return @"";
    }
    return [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeyBSSID];
}

// 越狱信息
#pragma mark - jailbroken Information
+ (BOOL)jailbroken {
    NSArray *appFilePath = @[@"/Applications/Cydia.app",
                             @"/Applications/limera1n.app",
                             @"/Applications/greenpois0n.app",
                             @"/Applications/blackra1n.app",
                             @"/Applications/blacksn0w.app",
                             @"/Applications/redsn0w.app",
                             @"/Applications/Absinthe.app",
                             @"/private/var/lib/apt"];
    BOOL jailbroken = NO;
    for (NSInteger i = 0; i < appFilePath.count; i++) {
        NSString *filePath = [appFilePath objectAtIndex:i];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            jailbroken = YES;
            break;
        }
    }
    return jailbroken;
}

#pragma mark - Processor Information
+ (NSInteger)numberProcessors {
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(processorCount)]) {
        NSInteger processorCount = [[NSProcessInfo processInfo] processorCount];
        return processorCount;
    } else {
        // 返回-1（没有找到）
        return -1;
    }
}

+ (NSInteger)numberActiveProcessors {
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(activeProcessorCount)]) {
        NSInteger activeProcessorCount = [[NSProcessInfo processInfo] activeProcessorCount];
        return activeProcessorCount;
    } else {
        // 返回-1（没有找到）
        return -1;
    }
}

+ (NSArray *)processorsUsage {
    @try {
        // Variables
        processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
        mach_msg_type_number_t _nuQBPUInfo, _numPrevCPUInfo = 0;
        unsigned _nuQBPUs;
        NSLock *_cpuUsageLock;
        
        // Get the number of processors from sysctl
        int _mib[2U] = { CTL_HW, HW_NCPU };
        size_t _sizeOfNuQBPUs = sizeof(_nuQBPUs);
        int _status = sysctl(_mib, 2U, &_nuQBPUs, &_sizeOfNuQBPUs, NULL, 0U);
        if (_status) {
            _nuQBPUs = 1;
        }
        
        // Allocate the lock
        _cpuUsageLock = [[NSLock alloc] init];
        
        // Get the processor info
        natural_t _nuQBPUsU = 0U;
        kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_nuQBPUsU, &_cpuInfo, &_nuQBPUInfo);
        if (err == KERN_SUCCESS) {
            [_cpuUsageLock lock];
            
            // Go through info for each processor
            NSMutableArray *processorInfo = [NSMutableArray new];
            for (unsigned i = 0U; i < _nuQBPUs; ++i) {
                Float32 _inUse, _total;
                if (_prevCPUInfo) {
                    _inUse = (
                              (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                              + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                              + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                              );
                    _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
                } else {
                    _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                    _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
                }
                // Add to the processor usage info
                [processorInfo addObject:@(_inUse / _total)];
            }
            
            [_cpuUsageLock unlock];
            if (_prevCPUInfo) {
                size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
                vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
            }
            // Retrieved processor information
            return processorInfo;
        } else {
            // Unable to get processor information
            return @[];
        }
    } @catch (NSException *exception) {
        // Getting processor information failed
        return @[];
    }
}

// 进程信息
#pragma mark - Process Info
+ (NSInteger)processID {
    @try {
        NSInteger pid = getpid();
        if (pid <= 0) {
            return -1;
        }
        return pid;
    } @catch (NSException *exception) {
        return -1;
    }
}

#pragma mark - Memory Info
+ (unsigned long long)physicalMemory {
    return [NSProcessInfo processInfo].physicalMemory;
}

+ (int64_t)usedMemory:(BOOL)inPercent {
    size_t length = 0;
    int mib[6] = {0};
    
    int pagesize = 0;
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    length = sizeof(pagesize);
    if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0) {
        return 0;
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics64_data_t vmStats;
    if (host_statistics64(mach_host_self(), HOST_VM_INFO, (host_info64_t)&vmStats, &count) != KERN_SUCCESS) {
        return 0;
    }
    int64_t used = vm_page_size * (vmStats.wire_count + vmStats.active_count);
    if (inPercent) {
        unsigned long long totalMemory = [self physicalMemory];
        return (used * 100) / totalMemory;
    }
    return used;
}

+ (uint64_t)availableMemory:(BOOL)inPercent {
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    if (host_statistics64(mach_host_self(), HOST_VM_INFO, (host_info64_t)&vmStats, &infoCount) != KERN_SUCCESS) {
        return NSNotFound;
    }
    uint64_t available = vm_page_size * (vmStats.free_count + vmStats.inactive_count);
    if (inPercent) {
        unsigned long long totalMemory = [self physicalMemory];
        return (available * 100) / totalMemory;
    }
    return available;
}

// 磁盘信息
#pragma mark - Disk Info
+ (float)totalDiskSpace {
    float totalSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
        return [fileSystemSizeInBytes floatValue];
    }
    
    return totalSpace;
}

+ (float)freeDiskSpace {
    float totalSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        return [fileSystemSizeInBytes floatValue];
    }
    
    return totalSpace;
}

// 本地化信息
#pragma mark - Localization Info
+ (NSString *)localeCountryCode {
    @try {
        NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        if (!countryCode || countryCode.length <= 0 || [countryCode isEqual:[NSNull null]]) {
            return @"";
        }
        return countryCode;
    } @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)localeIdentifier {
    @try {
        NSString *identifier = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
        if (!identifier || identifier.length <= 0 || [identifier isEqual:[NSNull null]]) {
            return @"";
        }
        return identifier;
    } @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)localeCollatorIdentifier {
    @try {
        NSString *identifier = [[NSLocale currentLocale] objectForKey:NSLocaleCollatorIdentifier];
        if (!identifier || identifier.length <= 0 || [identifier isEqual:[NSNull null]]) {
            return @"";
        }
        return identifier;
    } @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)localeLanguagesCode {
    @try {
        NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        if (!languageCode || languageCode.length <= 0 || [languageCode isEqual:[NSNull null]]) {
            return @"";
        }
        return languageCode;
    } @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)localeCurrencySymbol {
    @try {
        NSString *currency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
        if (!currency || currency.length <= 0 || [currency isEqual:[NSNull null]]) {
            return @"";
        }
        return currency;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)localeCurrencyCode {
    @try {
        NSString *currency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
        if (!currency || currency.length <= 0 || [currency isEqual:[NSNull null]]) {
            return @"";
        }
        return currency;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)localeCalendar {
    @try {
        NSString *calendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
        if (!calendar || calendar.length <= 0 || [calendar isEqual:[NSNull null]]) {
            return @"";
        }
        return calendar;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

+ (NSString *)timeZone {
    @try {
        NSTimeZone *localTime = [NSTimeZone systemTimeZone];
        NSString *timeZone = [localTime name];
        if (timeZone == nil || timeZone.length <= 0 || [timeZone isEqual:[NSNull null]]) {
            return @"";
        }
        return timeZone;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

// 应用程序信息
#pragma mark - Application Info
+ (uint64_t)appCPUUsage {
    @try {
        struct task_vm_info info;
        mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
        
        if (task_info(mach_host_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count) != KERN_SUCCESS) {
            return -1;
        }
        return info.phys_footprint;
    } @catch (NSException *exception) {
        return -1;
    }
}

+ (uint64_t)appMemoryUsage {
    struct task_vm_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    int r = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count);
    if (r == KERN_SUCCESS) {
        return info.phys_footprint;
    } else {
        return -1;
    }
}

// 电池信息
#pragma mark - Battery Info
+ (float)batteryLevel {
    @try {
        UIDevice *device = [UIDevice currentDevice];
        device.batteryMonitoringEnabled = YES;
        
        float batteryLevel = 0.0;
        float batteryCharge = [device batteryLevel];
        
        if (batteryCharge > 0.f) {
            batteryLevel = batteryCharge * 100;
            return batteryLevel;
        } else {
            return -1;
        }
    } @catch (NSException *exception) {
        return -1;
    }
}

+ (BOOL)isCharging {
    @try {
        UIDevice *device = [UIDevice currentDevice];
        device.batteryMonitoringEnabled = YES;
        
        if ([device batteryState] == UIDeviceBatteryStateCharging || [device batteryState] == UIDeviceBatteryStateFull) {
            return YES;
        } else {
            return NO;
        }
    } @catch (NSException *exception) {
        return NO;
    }
}

+ (BOOL)fullyCharged {
    @try {
        UIDevice *device = [UIDevice currentDevice];
        device.batteryMonitoringEnabled = YES;
        
        if ([device batteryState] == UIDeviceBatteryStateFull) {
            return YES;
        } else {
            return NO;
        }
    } @catch (NSException *exception) {
        return NO;
    }
}

+ (NSUInteger)BUSFrequency {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, HW_BUS_FREQ};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

#pragma mark - CPU Info
+ (NSInteger)CPUNumber {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

+ (NSUInteger)CPUFrequency {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, HW_CPU_FREQ};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

+ (NSString *)CPUType {
    const NXArchInfo *info = NXGetLocalArchInfo();
    if (info == NULL) {
        return @"";
    }

    return [NSString stringWithUTF8String:info->description];
}

+ (NSUInteger)activeCPUCount {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"hw.activecpu"];
}

+ (NSUInteger)physicalCPUCount {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"hw.physicalcpu"];
}

+ (NSUInteger)physicalCPUMaxCount {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"hw.physicalcpu_max"];
}

+ (NSUInteger)logicalCPUCount {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"hw.logicalcpu"];
}

+ (NSUInteger)logicalCPUMaxCount {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"hw.logicalcpu_max"];
}

#pragma mark - Kern Info
+ (NSString *)kernHostName {
    return [QBDevice getSysCtlChrWithSpecifier:"kern.hostname"];
}

+ (NSString *)kernOSType {
    return [QBDevice getSysCtlChrWithSpecifier:"kern.ostype"];
}

+ (NSString *)kernOSVersion {
    return [QBDevice getSysCtlChrWithSpecifier:"kern.osversion"];
}

+ (NSUInteger)kernOSRevision {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"kern.osrevision"];
}

+ (NSString *)kernVersion {
    return [QBDevice getSysCtlChrWithSpecifier:"kern.version"];
}

+ (NSUInteger)kernMaxvnodes {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"kern.maxvnodes"];
}

+ (NSUInteger)kernMaxproc {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"kern.maxproc"];
}

+ (NSUInteger)kernMaxfiles {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"kern.maxfiles"];
}

+ (NSUInteger)kernNgroups {
    return (NSUInteger)[QBDevice getSysCtl64WithSpecifier:"kern.ngroups"];
}

+ (int)kernClockrate {
    struct clockinfo clockInfo;
    [QBDevice getSysCtlPtrWithSpecifier:"kern.clockrate" pointer:&clockInfo size:sizeof(struct clockinfo)];

    return clockInfo.hz;
}

+ (NSUInteger)kernBootTime {
    struct timeval bootTime;
    [QBDevice getSysCtlPtrWithSpecifier:"kern.boottime" pointer:&bootTime size:sizeof(struct timeval)];

    return bootTime.tv_sec;
}

+ (BOOL)kernSafeBoot {
    return [QBDevice getSysCtl64WithSpecifier:"kern.safeboot"] > 0;
}

#pragma mark - Version
+ (BOOL)versionEqualTo:(NSString *)version
{
    return ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame);
}

+ (BOOL)versionGreaterThan:(NSString *)version
{
    return ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending);
}

+ (BOOL)versionGreaterThanOrEqualTo:(NSString *)version
{
    return ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending);
}

+ (BOOL)versionLessThan:(NSString *)version
{
    return ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending);
}

+ (BOOL)versionLessThanOrEqualTo:(NSString *)version
{
    return ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedDescending);
}

#pragma mark - private
+ (uint64_t)getSysCtl64WithSpecifier:(char *)specifier {
    size_t size = -1;
    uint64_t val = 0;
    
    if (!specifier || (strlen(specifier) == 0) || (sysctlbyname(specifier, NULL, &size, NULL, 0) == -1) || (size == -1)) {
        return -1;
    }
    
    if (sysctlbyname(specifier, &val, &size, NULL, 0) == -1) {
        return -1;
    }
    
    return val;
}

+ (NSString *)getSysCtlChrWithSpecifier:(char *)specifier {
    size_t size = -1;
    char *val;
    NSString *result = @"";
    
    if (!specifier || (strlen(specifier) == 0) || (sysctlbyname(specifier, NULL, &size, NULL, 0) == -1) || (size == -1)) {
        return result;
    }
    
    val = (char *)malloc(size);
    
    if (sysctlbyname(specifier, val, &size, NULL, 0) == -1) {
        free(val);
        return result;
    }
    
    result = [NSString stringWithUTF8String:val];
    free(val);
    return result;
}

+ (void *)getSysCtlPtrWithSpecifier:(char *)specifier pointer:(void *)ptr size:(size_t)size {
    if (!specifier || (strlen(specifier) == 0) || (sysctlbyname(specifier, NULL, &size, NULL, 0) == -1) || (size == -1)) {
        return nil;
    }
    
    if (sysctlbyname(specifier, ptr, &size, NULL, 0) == -1) {
        return nil;
    }
    
    return ptr;
}

+ (NSUInteger)getSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger)results;
}

@end
