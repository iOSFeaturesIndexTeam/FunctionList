
//
//  AppDelegate+Extend.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "AppDelegate+Extend.h"

@implementation AppDelegate (Extend)
+ (UINavigationController *)appRootVC{
     return (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}
+ (void)currentVC:(Class)currentVC Exec:(void (^)(UIViewController *vc))option{
    for (UIViewController *vc in [AppDelegate appRootVC].viewControllers) {
        if ([[vc className] isEqualToString:[currentVC className]]) {
            option(vc);
        }
    }
}
@end
