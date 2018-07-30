//
//  UIViewController+BTExtension.m
//  MissionHall
//
//  Created by xueMingLuan on 2017/8/9.
//  Copyright © 2017年 xinhui wang. All rights reserved.
//

#import "UIViewController+BTExtension.h"

@implementation UIViewController (BTExtension)

+ (UIViewController *)union_topViewController {
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    return [self union_topViewControllerOnController:controller];
}

+ (UIViewController *)union_topViewControllerOnController:(UIViewController *)controller {
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)controller;
        return [self union_topViewControllerOnController:navigationController.visibleViewController];
    }
    
    if (controller.presentedViewController) {
        return [self union_topViewControllerOnController:controller.presentedViewController];
    }
    
    return controller;
}

@end
