//
//  NSHTTPCookieStorage+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSHTTPCookieStorage+QBExtension.h"

@implementation NSHTTPCookieStorage (QBExtension)

#pragma mark - FreezeDry
- (void)qbSaveCookieWithFilePath:(NSString *)path {
    NSMutableArray *cookieData = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        NSMutableDictionary *cookieDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
        cookieDictionary[NSHTTPCookieName] = cookie.name;
        cookieDictionary[NSHTTPCookieValue] = cookie.value;
        cookieDictionary[NSHTTPCookieDomain] = cookie.domain;
        cookieDictionary[NSHTTPCookiePath] = cookie.path;
        cookieDictionary[NSHTTPCookieSecure] = (cookie.isSecure ? @"YES" : @"NO");
        cookieDictionary[NSHTTPCookieVersion] = [NSString stringWithFormat:@"%zd", cookie.version];
        if (cookie.expiresDate)
            cookieDictionary[NSHTTPCookieExpires] = cookie.expiresDate;
        
        [cookieData addObject:cookieDictionary];
    }
    
    [cookieData writeToFile:path atomically:YES];
}

- (void)qbReadCookieWithFilePath:(NSString *)path {
    NSMutableArray* cookies = [NSMutableArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *cookieData in cookies) {
        [self setCookie:[NSHTTPCookie cookieWithProperties:cookieData]];
    }
}

+ (void)qbDeleteCookie {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

@end
