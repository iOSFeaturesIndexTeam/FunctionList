//
//  AppDelegate+Extend.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Extend)
+ (UINavigationController *)appRootVC;
+ (void)currentVC:(Class)currentVC exec:(void (^)(UIViewController *vc))option;
@end
