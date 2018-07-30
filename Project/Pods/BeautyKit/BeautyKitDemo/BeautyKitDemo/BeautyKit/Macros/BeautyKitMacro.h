//
//  BeautyKitMacro.h
//  BeautyKit
//
//  Created by xueMingLuan on 2017/5/5.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "BeautyKitMacro.h"
#import <UIKit/UIKit.h>
static inline CGFloat BGDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}


// iPhoneX的上下总距离
#define kIPhoneXOffset 78.0f
#define kIPhoneXTop 44.0f
#define kIPhoneXBottom 34.0f
#define kIPhoneXCameraIn9x16Bottom 101.0f
#define kIPhoneXCameraIn9x16Offset 145.f
#define kScreenAdjustValue(x) [UIScreen mainScreen].bounds.size.width / 375.0f * x
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define DeviceIsX                (UNION_SCREEN_HEIGHT == 812.0f)
#define isPad [UIDevice currentDevice].isPad
#define isPlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否是iPhone5
#define isPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)]\
? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)\
|| CGSizeEqualToSize(CGSizeMake(1136, 640), [[UIScreen mainScreen] currentMode].size) : NO)

// 尺寸定义
#define UNION_SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define UNION_SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define UNION_SCREEN_SCALE [UIScreen  mainScreen].scale
#define UNION_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define UNION_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UNION_NAVI_HEIGHT 44.0f
#define UNION_SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)

// 适配
#define UNION_ADJUST_VALUE(a) (a) * [UIScreen mainScreen].bounds.size.height / 667

// 颜色
#define UNION_COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UNION_COLOR_RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1.0f)]

#define UNION_COLOR_HEXSTRING(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                                                   green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UNION_ALPHA_COLORW_HEXSTR(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24))/255.0 \
                                                        green:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 \
                                                         blue:((float)((rgbaValue & 0xFF00) >> 8))/255.0 \
                                                        alpha:((float)(rgbaValue & 0xFF))/255.0]

// 弱引用
#define UNION_WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define UNION_STR_FROM_INT( __x ) [NSString stringWithFormat:@"%d", (__x)]
#define UNION_STR_FROM_FLOAT( __x ) [NSString stringWithFormat:@"%f", (__x)]
#define UNION_STR_FROM_DOUBLE( __x ) [NSString stringWithFormat:@"%f", (__x)]
#define UNION_STR_FROM_INTEGER( __x ) [NSString stringWithFormat:@"%zd", (__x)]

#ifdef DEBUG
#define  UNION_Log(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define  UNION_Log(...) NSLog(@"%@\n",[NSString stringWithFormat:__VA_ARGS__])
#endif

#define UNION_iOS11_Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#define UNION_iOS10_Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)
#define UNION_iOS9_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)


#if DEBUG
#define KCLog(format, ...) printf("[Class: <%p %s--->Line(%d) > Method: %s] + Log--->\n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define KCLog(format, ...)
#endif

