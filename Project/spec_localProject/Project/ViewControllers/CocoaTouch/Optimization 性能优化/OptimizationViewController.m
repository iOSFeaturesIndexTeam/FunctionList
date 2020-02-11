//
//  OptimizationViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2020/2/11.
//  Copyright © 2020 Little.Daddly. All rights reserved.
//

#import "OptimizationViewController.h"

@interface OptimizationViewController ()

@end

@implementation OptimizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //GPU 离屏渲染 导致的滑动掉帧
    [self offscreenRendering];
}

- (void)offscreenRendering{
    // 使用CAShapeLayer he UIBezierPath 设置圆角
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"demo"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = imageView.bounds;
    maskLayer.path = maskPath.CGPath;
    //mask 属性接手CALyaer 类型 设置alpha通道来实现 圆角功能
    imageView.layer.mask = maskLayer;
    [self.view addSubview:imageView];
}

@end
