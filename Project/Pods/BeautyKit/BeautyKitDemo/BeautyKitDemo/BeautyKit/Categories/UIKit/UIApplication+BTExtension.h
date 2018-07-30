//
//  UIApplication+MHOpenURL.h
//  MissionHall
//
//  Created by wl on 2017/8/18.
//  Copyright © 2017年 xinhui wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (BTExtension)

+ (void)union_openURL:(NSURL *)url;

+ (void)union_openURLStr:(NSString *)urlStr;

@end
