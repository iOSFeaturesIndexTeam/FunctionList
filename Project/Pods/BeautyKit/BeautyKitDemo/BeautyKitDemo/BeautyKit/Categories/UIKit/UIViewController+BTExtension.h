//
//  UIViewController+BTExtension.h
//  MissionHall
//
//  Created by xueMingLuan on 2017/8/9.
//  Copyright © 2017年 xinhui wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BTExtension)

/**
 获取当前最顶层的控制器
 */
+ (UIViewController *)union_topViewController;
+ (UIViewController *)union_topViewControllerOnController:(UIViewController *)controller;

@end
