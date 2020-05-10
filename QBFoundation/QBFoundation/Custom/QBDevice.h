//
//  QBDevice.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/3.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
设备类型

- QBDeviceFamilyiPhone: iPhone
- QBDeviceFamilyiPod: iPod
- QBDeviceFamilyiPad: iPad
- QBDeviceFamilyAppleTV: AppleTV
- QBDeviceFamilyWatch: Watch
- QBDeviceFamilySimulator: Simulator
- QBDeviceFamilyUnknow: Unknow
*/
typedef NS_ENUM(NSUInteger, QBDeviceFamily) {
    QBDeviceFamilyiPhone,
    QBDeviceFamilyiPod,
    QBDeviceFamilyiPad,
    QBDeviceFamilyAppleTV,
    QBDeviceFamilyWatch,
    QBDeviceFamilySimulator,
    QBDeviceFamilyUnknow
};

/// 运营商类型
typedef NS_ENUM(NSUInteger, SSOperatorsType) {
    SSOperatorsTypeChinaTietong,        //中国铁通
    SSOperatorsTypeTelecom,             //中国电信
    SSOperatorsTypeChinaUnicom,         //中国联通
    SSOperatorsTypeChinaMobile,         //中国移动
    SSOperatorsTypeUnknown,             //未知
};


/// 提供设备信息
@interface QBDevice : NSObject


/// 获取设备的广告标识符，简化“ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString”
+ (NSString *)advertisingIdentifier;

/// ip地址
+ (NSString *)IPAddress;


/// mac地址
+ (NSString *)macAdrress;

// 硬件信息
#pragma mark - Hardware Information
/**
 返回机器硬件类型
 eg. "iPhone8,1"
 
 @return NSString
 */
+ (NSString *)hardwareMachine;

/**
 系统类型
 eg. "Darwin"
 
 @return NSString
 */
+ (NSString *)OSType;

/**
 系统内核信息
 eg. "Darwin Kernel Version 18.0.0: Tue Aug 14 22:07:19 PDT 2018; root:xnu-4903.202.2~1/RELEASE_ARM64_S8000"
 @return NSString
 */
+ (NSString *)OSKernelInfo;


/// 字节顺序  Little endian、Big endian、-
+ (NSString *)endianness;

/// 获取设备的系列
+ (QBDeviceFamily)deviceFamily;


/// 获取设备的机器类型，eg.iPhone 4S
+ (NSString *)mobileModel;


/// 系统正常运行的时间 格式为dd hh mm
+ (NSString *)systemUptime;

/// 系统正常运行的时间 单位毫秒
+ (NSTimeInterval)bootUptime;

/// 简化"UIDevice.currentDevice.model"    eg. "iPhone"
+ (NSString *)qbModel;

/**
 简化"UIDevice.currentDevice.identifierForVendor.UUIDString"
 eg. "F0E635CC-084C-4538-9AA4-4F58BD4DBBF9"
 
 @return NSString
 */
+ (NSString *)identifierForVendor;

/// 简化"UIDevice.currentDevice.localizedModel"   eg. "iPhone"
+ (NSString *)localizedModel;

/// 简化"UIDevice.currentDevice.name"    eg. "xt的iPhone"
+ (NSString *)name;

/// 简化"UIDevice.currentDevice.systemVersion"    eg. "11.4"
+ (NSString *)systemVersion;

/// 简化"UIDevice.currentDevice.systemName"   eg. "iOS"
+ (NSString *)systemName;

/// 获取屏幕宽度
+ (CGFloat)screenWidth;

/// 获取屏幕高度
+ (CGFloat)screenHeight;

/// 状态栏的高度
+ (CGFloat)statusBarHeight;

/// 获取屏幕亮度
+ (CGFloat)screenBrightness;

/// 判断设备是否为iPhone
+ (BOOL)isiPhone;

/// 判断设备是否为iPhone4
+ (BOOL)isiPhone4;

/// 判断设备是否为iPhone5
+ (BOOL)isiPhone5;

/// 判断设备是否为iPhone 6系列，特制屏幕大小为375*667
+ (BOOL)isiPhone6Series;

/// 判断设备是否为iPhone 6 Plus系列，特制屏幕大小为414*736
+ (BOOL)isiPhone6PlusSeries;

/// 判断设备是否为iPhone X系列， 包括 XS Max
+ (BOOL)isiPhoneXSeries;

// 运营商信息
#pragma mark - Carrier Information
/// 获取运营商类型 eg. @[@(SSOperatorsTypeChinaUnicom)];   iphone 11 以后支持双SIM卡
+ (NSArray<NSNumber *> *)getOperatorsType;

/// 运营商的名字  eg. "中国移动"
+ (NSArray<NSString *> *)carrierName;

/// 运营商对应的国家编号  eg. "460"
+ (NSArray<NSString *> *)carrierMobileCountryCode;

/// 运营商对应的网络编号  eg. "02"
+ (NSArray<NSString *> *)carrierMobileNetworkCode;

/// 运营商对应的国家编号与网络编号    eg. "460+02"
+ (NSArray<NSString *> *)carrierSIMCompany;

/// 运营商对应的国家代码  eg. "cn"
+ (NSArray<NSString *> *)carrierISOCountryCode;

/// 是否支持voip  BOOL
+ (NSArray<NSNumber *> *)carrierAllowsVOIP;

/// 是否飞行模式
+ (BOOL)isAirPlaneMode;

/// 能否拨打电话
+ (BOOL)canMakePhoneCalls;

// WiFi信息
#pragma mark - WiFi Information
/// WiFi是否启用
+ (BOOL)isWiFiEnabled;

/// 当前设备连接的wifi名字
+ (NSString *)connectingWIFIName;

/// 当前设备连接的wifi地址
+ (NSString *)connectingWIFIAddress;

// 越狱信息
#pragma mark - jailbroken Information
/// 是否越狱
+ (BOOL)jailbroken;

// 处理器信息
#pragma mark - Processor Information

/// 处理器的数量
+ (NSInteger)numberProcessors;

/// 活动的处理器的数量
+ (NSInteger)numberActiveProcessors;

/// 获取处理器使用信息（eg，[“0.2216801”，“0.1009614”]）
+ (NSArray *)processorsUsage;

// 进程信息
#pragma mark - Process Info
/// 进程id
+ (NSInteger)processID;

// 内存信息
#pragma mark - Memory Info
/// 当前设备的所有物理内存大小，单位为byte
+ (unsigned long long)physicalMemory;

/**
 获取当前设备已使用的内存，单位为byte

 @param inPercent 是否使用百分比
 @return int64_t
 */
+ (int64_t)usedMemory:(BOOL)inPercent;

/// 获取当前设备可用的内存，单位为byte
/// @param inPercent 是否使用百分比
+ (uint64_t)availableMemory:(BOOL)inPercent;

// 磁盘信息
#pragma mark - Disk Info
/// 总的磁盘大小，单位为byte
+ (float)totalDiskSpace;

/// 可用磁盘大小，单位为byte
+ (float)freeDiskSpace;

// 本地化信息
#pragma mark - Localization Info
/// 地区代码 eg. "CN"
+ (NSString *)localeCountryCode;

/// 区域标识符，eg. "zh_CN"
+ (NSString *)localeIdentifier;

/// eg. "zh-Hans-CN"
+ (NSString *)localeCollatorIdentifier;

/// 语言代码 eg. "zh"
+ (NSString *)localeLanguagesCode;

/// 货币符号 eg. "¥"
+ (NSString *)localeCurrencySymbol;

/// 货币代码 eg. "CNY"
+ (NSString *)localeCurrencyCode;

/// 本地日历
+ (NSString *)localeCalendar;

/// 获取系统时区的名字，简化"NSTimeZone.systemTimeZone.name"
+ (NSString *)timeZone;

// 应用程序信息
#pragma mark - Application Info
/// 当前应用程序占用的cpu
+ (uint64_t)appCPUUsage;

/// 当前应用程序占用的内存
+ (uint64_t)appMemoryUsage;

// 电池信息
#pragma mark - Battery Info
/// 电量 百分比
+ (float)batteryLevel;

/// 是否正在充电
+ (BOOL)isCharging;

/// 是否完全充满电
+ (BOOL)fullyCharged;

/// BUS频率
+ (NSUInteger)BUSFrequency;

// CPU信息
#pragma mark - CPU Info
/// CPU核心数
+ (NSInteger)CPUNumber;

/// CPU频率
+ (NSUInteger)CPUFrequency;

/// CPU类型
+ (NSString *)CPUType;

/// 活动CPU个数
+ (NSUInteger)activeCPUCount;

/// 物理CPU个数
+ (NSUInteger)physicalCPUCount;

/// 物理CPU最大个数
+ (NSUInteger)physicalCPUMaxCount;

/// 逻辑CPU个数
+ (NSUInteger)logicalCPUCount;

/// 逻辑CPU最大个数
+ (NSUInteger)logicalCPUMaxCount;

// 内核信息
#pragma mark - Kern Info
+ (NSString *)kernHostName;
+ (NSString *)kernOSType;
+ (NSString *)kernOSVersion;
+ (NSUInteger)kernOSRevision;
+ (NSString *)kernVersion;
+ (NSUInteger)kernMaxvnodes;
+ (NSUInteger)kernMaxproc;
+ (NSUInteger)kernMaxfiles;
+ (NSUInteger)kernNgroups;
+ (int)kernClockrate;
+ (NSUInteger)kernBootTime;
+ (BOOL)kernSafeBoot;

#pragma mark - Version
+ (BOOL)versionEqualTo:(NSString *)version;
+ (BOOL)versionGreaterThan:(NSString *)version;
+ (BOOL)versionGreaterThanOrEqualTo:(NSString *)version;
+ (BOOL)versionLessThan:(NSString *)version;
+ (BOOL)versionLessThanOrEqualTo:(NSString *)version;

@end

NS_ASSUME_NONNULL_END
