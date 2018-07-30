//
//  UIApplication+MHOpenURL.m
//  MissionHall
//
//  Created by wl on 2017/8/18.
//  Copyright © 2017年 xinhui wang. All rights reserved.
//

#import "UIApplication+BTExtension.h"

@implementation UIApplication (BTExtension)

+ (void)union_openURL:(NSURL *)url {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

+ (void)union_openURLStr:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    [self union_openURL:url];
}

@end
