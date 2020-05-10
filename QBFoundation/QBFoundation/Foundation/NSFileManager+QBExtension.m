//
//  NSFileManager+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSFileManager+QBExtension.h"

@implementation NSFileManager (QBExtension)

+ (BOOL)qbDeleteFileWithFilePath:(NSString *)filePath fileName:(NSString *)fileName {
    NSString *fullPath = [filePath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        return [fileManager removeItemAtPath:filePath error:nil];
    }
    
    return YES;
}

+ (BOOL)qbSaveFileInDocumentWithFolderName:(NSString *)folderName fileName:(NSString *)fileName data:(NSData *)data {
    NSURL *filePath = [[[NSFileManager qbDocumentURL] URLByAppendingPathComponent:folderName] URLByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] createFileAtPath:[filePath path] contents:data attributes:nil];
}

+ (BOOL)qbIsExistedFolderInDocument:(NSString *)folderName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *filePath = [[NSFileManager qbDocumentURL] URLByAppendingPathComponent:folderName];
    BOOL created = NO;
    if (![fileManager fileExistsAtPath:[filePath path]]) {
        if ([fileManager createDirectoryAtURL:filePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            created = YES;
        }
    } else {
        created = YES;
    }
    
    return created;
}

+ (nullable NSString *)qbFilePathInDocumentWithFolderName:(NSString *)folderName fileName:(NSString *)fileName {
    NSURL *filePath = [[[NSFileManager qbDocumentURL] URLByAppendingPathComponent:folderName] URLByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[filePath path]]) {
        return nil;
    }
    
    return [filePath path];
}

+ (NSURL *)qbDocumentURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)qbDocumentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)qbCachesURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)qbCachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)qbLibraryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)qbLibraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}


@end
