//
//  NSString+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/8.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QBExtension)

#pragma mark - NSString -> Number

- (double)qbDoubleValue;

- (float)qbFloatValue;

- (int)qbIntValue;

- (NSInteger)qbIntegerValue NS_AVAILABLE(10_5, 2_0);

- (unsigned long long)qbUnsignedLongLongValue;

- (long long)qbLongLongValue NS_AVAILABLE(10_5, 2_0);

- (long)qbLongValue;

/// 返回BOOL值
- (BOOL)qbBoolValue NS_AVAILABLE(10_5, 2_0);

/// 返回index对应的unichar值
/// @param index 索引
- (unichar)qbCharacterAtIndex:(NSUInteger)index;

/// 是否为整型
- (BOOL)qbIsInteger;

/// 是否为浮点型
- (BOOL)qbIsFloat;

/// 反转字符串 eg：abc -> cba
- (NSString *)qbReverseString;

/// 使字符串首字母大写 eg：abc -> Abc
- (NSString *)qbUppercaseFirstString;

/// 使字符串首字母小写 eg：ABC -> aBC
- (NSString *)qbLowercaseFirstString;

/// 获取第一个字
- (NSString *)qbFirstCharacter;

/// 获取最后一个字
- (NSString *)qbLastCharacter;

#pragma mark - Char

/// 获取字字符串，不包含charStart和charEnd
/// @param string 原始String
/// @param charStart 开始char
/// @param charEnd 结束char
+ (NSString *)qbSearchInString:(NSString *)string charStart:(char)charStart charEnd:(char)charEnd;

/// 获取字字符串，不包含charStart和charEnd
/// @param charStart 开始char
/// @param charEnd 结束char
- (NSString *)qbSearchCharStart:(char)charStart charEnd:(char)charEnd;
- (NSInteger)qbIndexOfCharacter:(char)character;
- (NSString *)qbSubstringFromCharacter:(char)character;
- (NSString *)qbSubstringToCharacter:(char)character;

#pragma mark - Substring
/**
 获取从索引from开始，长度为length的字符串

 @param from 开始索引
 @param length 长度
 @return NSString
 */
- (NSString *)qbSubstringFromIndex:(NSUInteger)from length:(NSUInteger)length;

/**
 获取从索引from开始到索引to结束的字符串

 @param from 开始索引
 @param toIndex 结束索引
 @return NSString
 */
- (NSString *)qbSubstringFromIndex:(NSUInteger)from toIndex:(NSUInteger)toIndex;

#pragma mark - Random
/// 获取一个随机字符串 默认长度为10
+ (nullable NSString *)qbGenerateRandomString;

/// 获取一个指定长度的随机字符串
/// @param number 长度
+ (nullable NSString *)qbGenerateRandomStringWithLength:(NSInteger)number;

#pragma mark - Init
/**
 把void *转换为NSString

 @param pointer 指针
 @return NSString
 */
+ (NSString *)qbStringWithPointer:(void *)pointer;

/// 把CGFloat转换为NSString
/// @param cgFloat CGFloat
+ (NSString *)qbStringWithCGFloat:(CGFloat)cgFloat;

/// 把NSUInteger转换为NSString
/// @param unsignedInteger NSUInteger
+ (NSString *)qbStringWithUnsignedInteger:(NSUInteger)unsignedInteger;

/// 把NSInteger转换为NSString
/// @param integer NSInteger
+ (NSString *)qbStringWithInteger:(NSInteger)integer;

/// 把id转换为NSString
/// @param object id
+ (NSString *)qbStringWithObject:(id)object;

/// 把long long转换为NSString
/// @param longLong long long
+ (NSString *)qbStringWithLongLong:(long long)longLong;

/// 把unsigned long long转换为NSString
/// @param unsignedLongLong unsigned long long
+ (NSString *)qbStringWithUnsignedLongLong:(unsigned long long)unsignedLongLong;

/// 把long转换为NSString
/// @param longv long
+ (NSString *)qbStringWithLong:(long)longv;

/// 把unsigned long转换为NSString
/// @param unsignedLong unsigned long
+ (NSString *)qbStringWithUnsignedLong:(unsigned long)unsignedLong;

/// 把int转换为NSString
/// @param intv int
+ (NSString *)qbStringWithInt:(int)intv;

/// 把unsigned int转换为NSString
/// @param unsignedInt unsigned int
+ (NSString *)qbStringWithUnsignedInt:(unsigned int)unsignedInt;

/// 把short转换为NSString
/// @param shortv short
+ (NSString *)qbStringWithShort:(short)shortv;

/// 把unsigned short转换为NSString
/// @param unsignedShort unsigned short
+ (NSString *)qbStringWithUnsignedShort:(unsigned short)unsignedShort;

/// 把char转换为NSString
/// @param charv char
+ (NSString *)qbStringWithChar:(char)charv;

/// 把unsigned char转换为NSString
/// @param unsignedChar unsigned char
+ (NSString *)qbStringWithUnsignedChar:(unsigned char)unsignedChar;

/// 把BOOL转换为NSString
/// @param aBOOL BOOL
+ (NSString *)qbStringWithBOOL:(BOOL)aBOOL;

/// 把float转换为NSString
/// @param aFloat float
+ (NSString *)qbStringWithFloat:(float)aFloat;

/// 把double转换为NSString
/// @param aDouble double
+ (NSString *)qbStringWithDouble:(double)aDouble;

/// 把int16转换为NSString
/// @param int16 int16
+ (NSString *)qbStringWithInt16:(int16_t)int16;

/// 把int32转换为NSString
/// @param int32 int32
+ (NSString *)qbStringWithInt32:(int32_t)int32;

/// 把int64转换为NSString
/// @param int64 int64
+ (NSString *)qbStringWithInt64:(int64_t)int64;

#pragma mark - URL
/// 对NSString进行url encode NSUTF8StringEncoding模式
- (NSString *)qbURLEncode;

/// 对NSString进行url decode NSUTF8StringEncoding模式
- (NSString *)qbURLDecode;

/**
 url query转成NSDictionary

 @param string string
 @return NSDictionary
 */
+ (NSDictionary *)qbURLParameters:(NSString *)string;

#pragma mark - UUID
/// 获取随机UUID
+ (NSString *)qbRandomUUID;

#pragma mark - Replace
- (NSString *)qbStringByReplacingWithRegex:(NSString *)regexString withString:(NSString *)replacement;

#pragma mark - Append
/// 追加数据
/// @param aString string
+ (NSString *)qbAppedString:(NSString * _Nonnull)aString, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Trims
/// 清除html标签
- (NSString *)qbStringByStrippingHTML;

/// 清除js脚本
- (NSString *)qbStringByRemovingScriptsAndStrippingHTML;

/// 去除空格
- (NSString *)qbTrimmingWhitespace;

/// 去除空格与空行
- (NSString *)qbTrimmingWhitespaceAndNewlines;

/// 去除换行
- (NSString *)qbTrimmingNewlines;

/// 移除前缀
/// @param prefix 前缀
- (NSString *)qbStringByRemovingPrefix:(NSString *)prefix;

/// 移除后缀
/// @param suffix 后缀
- (NSString *)qbStringByRemovingSuffix:(NSString *)suffix;

#pragma mark - Pinyin
/**
 无声调拼音 eg:张三丰 -> zhang san feng

 @param uppercase 是否大写字母
 @return NSString
 */
- (NSString *)qbPinyinUppercase:(BOOL)uppercase;

/**
 无声调拼音，每个首字母大写 eg:张三丰 -> Zhang San Feng

 @return NSString
 */
- (NSString *)qbPinyinCapitalized;

/**
 带声调拼音 eg:张三丰 -> zhāng sān fēng

 @param uppercase 是否大写字母
 @return NSString
 */
- (NSString *)qbPinyinWithPhoneticSymbolUppercase:(BOOL)uppercase;

/**
 带声调拼音，每个首字母大写 eg:张三丰 -> Zhāng Sān Fēng

 @return NSString
 */
- (NSString *)qbPinyinPhoneticSymbolCapitalized;

/**
 无声调无空格拼音 eg:张三丰 -> zhangsanfeng

 @param uppercase 是否大写字母
 @return NSString
 */
- (NSString *)qbPinyinWithoutBlankUppercase:(BOOL)uppercase;

/**
 无声调无空格拼音，每个首字母大写 eg:张三丰 -> ZhangSanFeng

 @return NSString
 */
- (NSString *)qbPinyinWithoutBlankCapitalized;

/**
 无声调拼音数组 eg:张三丰 -> @[@"zhang", @"san", @"feng"]

 @param uppercase 是否大写字母
 @return NSString
 */
- (NSArray *)qbPinyinArrayUppercase:(BOOL)uppercase;

/**
 无声调拼音数组，每个首字母大写 eg:张三丰 -> @[@"Zhang", @"San", @"Feng"]

 @return NSArray
 */
- (NSArray *)qbPinyinArrayCapitalized;

/**
 拼音首字母字符串 eg:张三丰 -> zsf

 @param uppercase 是否大写字母
 @return NSString
 */
- (NSString *)qbPinyinInitialsStringUppercase:(BOOL)uppercase;

/**
 拼音首字母数组 eg:张三丰 -> @[@"z", @"s", @"f"]

 @param uppercase 是否大写字母
 @return NSArray
 */
- (NSArray *)qbPinyinInitialsArrayUppercase:(BOOL)uppercase;

#pragma mark - Contains
/// 是否为空字符串 包含对nil、nsnull、@""的判断
/// @param string 字符串
+ (BOOL)qbIsEmpty:(NSString * _Nullable)string;

/// 是否包含中文
- (BOOL)qbIsContainChinese;

/// 是否包含空格
- (BOOL)qbIsContainBlank;

/// 是否包含字符集合
/// @param set set
- (BOOL)qbContainsCharacterSet:(NSCharacterSet *)set;

/// 是否包含字符串string
/// @param string string
- (BOOL)qbContainsString:(NSString *)string;

/// 获取包含的字符数量
- (int)qbContainsWordsCount;

/// 包含的第一个单词
- (nullable NSString *)qbContainsFirstWord;

/// 字符串包含的所有的单词
- (NSArray *)qbContainsAllWords;

/// 字符串包含的单词集合
- (NSSet *)qbContainsUniqueWords;

/// 字符串包含的单词数量
- (NSInteger)qbContainsNumberOfWords;

#pragma mark - Convert
/**
 Unicode编码的字符串转成NSString

 @return NSString
 */
- (NSString *)qbConvertUnicodeToString;

/**
 将html格式的字符串转换为NSMutableAttributedString的富文本

 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)qbConvertHTMLToAttributedString:(NSString *)htmlString;

#pragma mark - MIME
/**
 根据文件url后缀 返回对应的MIMEType

 @return NSString
 */
- (NSString *)qbMIMEType;

/**
 根据文件url后缀 返回对应的MIMEType

 @param extension url后缀
 @return NSString
 */
+ (NSString *)qbMIMETypeForExtension:(NSString *)extension;

/**
 常见MIME集合

 @return NSDictionary
 */
+ (NSDictionary *)qbMIMEDictionary;

#pragma mark - NormalRegEx
/**
 *  正则表达式简单说明
 *  语法：
 .       匹配除换行符以外的任意字符
 \w      匹配字母或数字或下划线或汉字
 \s      匹配任意的空白符
 \d      匹配数字
 \b      匹配单词的开始或结束
 ^       匹配字符串的开始
 $       匹配字符串的结束
 *       重复零次或更多次
 +       重复一次或更多次
 ?       重复零次或一次
 {n}     重复n次
 {n,}     重复n次或更多次
 {n,m}     重复n到m次
 \W      匹配任意不是字母，数字，下划线，汉字的字符
 \S      匹配任意不是空白符的字符
 \D      匹配任意非数字的字符
 \B      匹配不是单词开头或结束的位置
 [^x]     匹配除了x以外的任意字符
 [^aeiou]匹配除了aeiou这几个字母以外的任意字符
 *?      重复任意次，但尽可能少重复
 +?      重复1次或更多次，但尽可能少重复
 ??      重复0次或1次，但尽可能少重复
 {n,m}?     重复n到m次，但尽可能少重复
 {n,}?     重复n次以上，但尽可能少重复
 \a      报警字符(打印它的效果是电脑嘀一声)
 \b      通常是单词分界位置，但如果在字符类里使用代表退格
 \t      制表符，Tab
 \r      回车
 \v      竖向制表符
 \f      换页符
 \n      换行符
 \e      Escape
 \0nn     ASCII代码中八进制代码为nn的字符
 \xnn     ASCII代码中十六进制代码为nn的字符
 \unnnn     Unicode代码中十六进制代码为nnnn的字符
 \cN     ASCII控制字符。比如\cC代表Ctrl+C
 \A      字符串开头(类似^，但不受处理多行选项的影响)
 \Z      字符串结尾或行尾(不受处理多行选项的影响)
 \z      字符串结尾(类似$，但不受处理多行选项的影响)
 \G      当前搜索的开头
 \p{name}     Unicode中命名为name的字符类，例如\p{IsGreek}
 (?>exp)     贪婪子表达式
 (?<x>-<y>exp)     平衡组
 (?im-nsx:exp)     在子表达式exp中改变处理选项
 (?im-nsx)       为表达式后面的部分改变处理选项
 (?(exp)yes|no)     把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no
 (?(exp)yes)     同上，只是使用空表达式作为no
 (?(name)yes|no) 如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no
 (?(name)yes)     同上，只是使用空表达式作为no
 
 捕获
 (exp)               匹配exp,并捕获文本到自动命名的组里
 (?<name>exp)        匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
 (?:exp)             匹配exp,不捕获匹配的文本，也不给此分组分配组号
 零宽断言
 (?=exp)             匹配exp前面的位置
 (?<=exp)            匹配exp后面的位置
 (?!exp)             匹配后面跟的不是exp的位置
 (?<!exp)            匹配前面不是exp的位置
 注释
 (?#comment)         这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读
 
 *  表达式：\(?0\d{2}[) -]?\d{8}
 *  这个表达式可以匹配几种格式的电话号码，像(010)88886666，或022-22334455，或02912345678等。
 *  我们对它进行一些分析吧：
 *  首先是一个转义字符\(,它能出现0次或1次(?),然后是一个0，后面跟着2个数字(\d{2})，然后是)或-或空格中的一个，它出现1次或不出现(?)，
 *  最后是8个数字(\d{8})
 */

/**
 判断是否为纯字母

 @return BOOL
 */
- (BOOL)qbIsOnlyLetters;

/**
 判断是否为纯小写字母

 @return BOOL
 */
- (BOOL)qbIsOnlyLowercaseLetters;

/**
 判断是否为纯大写字母

 @return BOOL
 */
- (BOOL)qbIsOnlyUppercaseLetters;

/**
 返回字符串 串中的每个单词的首字母大写,其余字母小写
 
 @return BOOL
 */
- (BOOL)qbIsOnlyCapitalizedLetters;

/**
 判断是否全部为数字和字母（大小写）
 
 @return BOOL
 */
- (BOOL)qbIsOnlyNumbersAndLetters;

/**
 判断是否为纯数字
 
 @return BOOL
 */
- (BOOL)qbIsOnlyDecimalDigit;
    
/**
 判断是否为正整数

 @return BOOL
 */
- (BOOL)qbIsPositiceInteger;

/**
 判断是否为纯汉字
 
 @return BOOL
 */
- (BOOL)qbIsOnlyChinese;

/**
 判断是否只包含汉字、字母、数字

 @return BOOL
 */
- (BOOL)qbIsChineseOrLettersOrNumbers;

/**
 判断字符串是否以字母开头

 @param string 需要判断的文本
 @return BOOL
 */
+ (BOOL)qbIsLettersBegin:(NSString *)string;

/**
 判断字符串是否以汉字开头

 @param string 需要判断的文本
 @return BOOL
 */
+ (BOOL)qbIsChineseBegin:(NSString *)string;

/**
 验证密码:数字+英文(大小写)
 
 @return BOOL
 */
- (BOOL)qbIsPassword;

/**
 验证邮箱有效性
 
 @return BOOL
 */
- (BOOL)qbIsEmailAddress;

/**
 简单的身份证有效性
 
 @return BOOL
 */
- (BOOL)qbSimpleVerifyIdentityCardNum;

/**
 银行卡的有效性
 
 @return BOOL
 */
+ (BOOL)qbIsBankCardNo:(NSString *)string;

/**
 IP地址有效性
 
 @return BOOL
 */
- (BOOL)qbIsIPAddress;

/**
 Mac地址有效性
 
 @return BOOL
 */
- (BOOL)qbIsMacAddress;

/**
 网址的有效性
 
 @return BOOL
 */
- (BOOL)qbIsValidURL;

/**
 邮政编码的有效性
 
 @return BOOL
 */
- (BOOL)qbIsValidPostalCode;

/**
 工商税号的有效性
 
 @return BOOL
 */
- (BOOL)qbIsValidTaxNo;

/**
 手机号码的有效性

 @return BOOL
 */
- (BOOL)qbIsMobileNumber;

/**
 是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字

 @param minLenth 最小长度
 @param maxLenth 最长长度
 @param containChinese 是否包含中文
 @param firstCannotBeDigtal 首字母不能为数字
 @return BOOL
 */
- (BOOL)qbIsValidWithMinLenth:(NSInteger)minLenth
                     maxLenth:(NSInteger)maxLenth
               containChinese:(BOOL)containChinese
          firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字

 @param minLenth 最小长度
 @param maxLenth 最长长度
 @param containChinese 是否包含中文
 @param containDigtal 包含数字
 @param containLetter 包含字母
 @param containOtherCharacter 其他字符
 @param firstCannotBeDigtal 首字母不能为数字
 @return BOOL
 */
- (BOOL)qbIsValidWithMinLenth:(NSInteger)minLenth
                     maxLenth:(NSInteger)maxLenth
               containChinese:(BOOL)containChinese
                containDigtal:(BOOL)containDigtal
                containLetter:(BOOL)containLetter
        containOtherCharacter:(NSString *)containOtherCharacter
          firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 是否包含minLenth与maxLenth之间位数的汉字

 @param minLenth 最小长度
 @param maxLenth 最长长度
 @return BOOL
 */
- (BOOL)qbIsValidChineseCharWithMinLength:(NSUInteger)minLenth maxLength:(NSUInteger)maxLenth;

#pragma mark - CGSize
/**
 获取文本的长度 默认最大范围为CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) 显示1行
 @param string 文本
 @param font 字体
 */
+ (CGFloat)qbWidthWithString:(NSString *)string font:(UIFont *)font;

/**
 获取文本的大小
 @param string 文本
 @param font 字体
 @param maxSize 最大范围 若size为CGSizeZero，则size为CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
 @param lineBreakMode 换行默认：NSLineBreakByWordWrapping
 @return CGSize
 */
+ (CGSize)qbSizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize mode:(NSLineBreakMode)lineBreakMode;

/// 获取文本的大小
/// @param string v
/// @param font 字体
/// @param maxSize 最大范围 若size为CGSizeZero，则size为CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
/// @param wordSpacing 字间距
/// @param lineSpacing 行间距
/// @param paragraphSpacing 段落间距
/// @param lineBreakMode 换行默认：NSLineBreakByWordWrapping
+ (CGSize)qbSizeWithString:(NSString *)string
                      font:(UIFont *)font
                   maxSize:(CGSize)maxSize
               wordSpacing:(CGFloat)wordSpacing
               lineSpacing:(CGFloat)lineSpacing
          paragraphSpacing:(CGFloat)paragraphSpacing
                      mode:(NSLineBreakMode)lineBreakMode;
    
/**
 获取文本的宽度 宽度默认为CGFLOAT_MAX
 @param string 文本
 @param font 字体
 @param maxHeight 最大高度
 @return CGFloat
 */
+ (CGFloat)qbWidthWithString:(NSString *)string font:(UIFont *)font maxHeight:(CGFloat)maxHeight;

/// 在指定宽度的情况下，计算指定文本占用的行数
/// @param string 文本
/// @param font 字体
/// @param width 容器宽度
+ (NSInteger)qbCalcLinesOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

/**
 在指定宽度的情况下，计算指定文本的高度
 @param string 文本
 @param font 字体
 @param width 最大宽度
 @return 文本的高度
 */
+ (CGFloat)qbCalcHeightWithString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)width;

/**
 在指定宽度的情况下，计算指定文本的高度
 @param string 文本
 @param font 字体
 @param maxWidth 最大宽度
 @param lineSpacing 行间距
 @param paragraphSpacing 段落间距
 @return NSUInteger
 */
+ (CGFloat)qbCalcHeightWithString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing;

#pragma mark - Range

/// 获取子字符串在元字符串中出现的所有位置
/// @param substring 子字符串
/// @param str 元字符串
+ (NSArray<NSValue *> *)qbRangesOfSubstring:(NSString *)substring inString:(NSString *)str;

#pragma mark - Memory
- (void)qbClearMemory;

@end

@interface NSMutableString (QBExtension)

/**
 替换文本

 @param searchString searchString
 @param newString newString
 */
- (void)qbReplaceString:(NSString *)searchString withString:(NSString *)newString;

@end

NS_ASSUME_NONNULL_END
