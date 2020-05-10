//
//  NSURL+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSURL+QBExtension.h"

@implementation NSURL (QBExtension)

#pragma mark - QueryDictionary
- (nullable NSDictionary *)qbQueryDictionary {
    NSString *queryString = [self query];
    if (!queryString)
        return nil;
    
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionary];
    
    NSCharacterSet *charSetAmpersand = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSCharacterSet *charSetEqualsSign = [NSCharacterSet characterSetWithCharactersInString:@"="];
    for (NSString *fieldValuePair in [queryString componentsSeparatedByCharactersInSet:charSetAmpersand]) {
        NSArray *fieldValueArray = [fieldValuePair componentsSeparatedByCharactersInSet:charSetEqualsSign];
        if (fieldValueArray.count == 2) {
            NSString *filed = [fieldValueArray objectAtIndex:0];
            NSString *value = [fieldValueArray objectAtIndex:1];
            value = [value stringByRemovingPercentEncoding];
            if (filed && value) {
                [queryDictionary setObject:value forKey:filed];
            }
        }
    }
    return queryDictionary;
}

@end
