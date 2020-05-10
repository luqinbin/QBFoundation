//
//  QBFoundation.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/3.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#ifndef QBFoundation_h
#define QBFoundation_h

#import <Foundation/Foundation.h>

#if __has_include(<QBFoundation/QBFoundation.h>)

#import <QBFoundation/QBDefine.h>
#import <QBFoundation/QBDevice.h>
#import <QBFoundation/QBUtilities.h>
#import <QBFoundation/Foundation.h>
#import <QBFoundation/QBUI.h>
//#import <QBFoundation/QBQuartzCore.h>


#else

#import "QBDefine.h"
#import "QBDevice.h"
#import "QBUtilities.h"
#import "Foundation.h"
#import "QBUI.h"
//#import "QBQuartzCore.h"

#endif


#endif /* QBFoundation_h */
