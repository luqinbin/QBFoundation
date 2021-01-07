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
    
    NSString *str = @"pron. 你，您，你们（可用于名词前指定谈话对象）\npron. （用于口语和非正式书面语中表示泛指）你，任何人";
//    str = @"哈哈\n\n";
//    NSString *str1 = [str qbTrimmingNewlines];
    CGFloat width = [NSString qbWidthWithString:str font:[UIFont systemFontOfSize:16]];
    NSInteger lines = [NSString qbCalcLinesOfString:str font:[UIFont systemFontOfSize:16] width:QBDevice.screenWidth - 70];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(19, 400, QBDevice.screenWidth - 70, 20);
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = UIColor.yellowColor;
    label.text = str;
    label.numberOfLines = 0;
    [label sizeToFit];
    [self.view addSubview:label];
    
    int a;
}




@end
