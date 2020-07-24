//
//  ViewController.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/3.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "ViewController.h"
#import "QBFoundation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    view.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:view];
    
    [view.layer qbSetDottedlineBorderWithColor:[UIColor redColor] width:2 length:5 space:6 cap:kCALineCapRound];
    
    [view qbSetGradientBackgroundWithColors:@[UIColor.cyanColor, UIColor.yellowColor] locations:@[@(0), @(1)] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)];
        
    [view.layer qbSetShadowPathWithColor:UIColor.redColor shadowOpacity:1 shadowRadius:15 shadowSide:QBShadowPathBottom shadowPathWidth:5];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 300, 50, 50);
    [button setBackgroundColor:QBColorHex(@"#EB1C2B")];
    [self.view addSubview:button];
    [button qbAddClickBlock:^{
        NSLog(@"hhhhhaaa");
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 400, 200, 200)];
    imageView.image = [QBImage(@"test_icon") qbBlurredImage:1];
    
    [self.view addSubview:imageView];
}


@end
