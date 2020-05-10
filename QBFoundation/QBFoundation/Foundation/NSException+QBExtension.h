//
//  NSException+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSException (QBExtension)

- (NSArray *)qbBacktrace;

@end

NS_ASSUME_NONNULL_END
