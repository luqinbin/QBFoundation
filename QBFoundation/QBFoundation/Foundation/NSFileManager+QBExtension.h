//
//  NSFileManager+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (QBExtension)

/**
 删除文件

 @param filePath 文件路径
 @param fileName 文件名字
 @return BOOL
 */
+ (BOOL)qbDeleteFileWithFilePath:(NSString *)filePath fileName:(NSString *)fileName;

/**
 保存数据

 @param folderName 文件夹名词
 @param fileName 文件名字
 @param data 数据
 @return BOOL
 */
+ (BOOL)qbSaveFileInDocumentWithFolderName:(NSString *)folderName fileName:(NSString *)fileName data:(NSData *)data;
/**
 判断Document目录下是否存在指定文件夹

 @param folderName 文件夹名字
 @return BOOL
 */
+ (BOOL)qbIsExistedFolderInDocument:(NSString *)folderName;

+ (nullable NSString *)qbFilePathInDocumentWithFolderName:(NSString *)folderName fileName:(NSString *)fileName;

+ (NSURL *)qbDocumentURL;

+ (NSString *)qbDocumentPath;

+ (NSURL *)qbCachesURL;

+ (NSString *)qbCachesPath;

+ (NSURL *)qbLibraryURL;

+ (NSString *)qbLibraryPath;

@end

NS_ASSUME_NONNULL_END
