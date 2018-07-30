//
//  UIColor+BTExtension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/5.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define union_ColorFromRGBBytes(r,g,b) [UIColor \
colorWithRed:   ((CGFloat)(r)/255.0) \
green:          ((CGFloat)(g)/255.0) \
blue:           ((CGFloat)(b)/255.0) \
alpha:          1.0]

#define union_ColorFromRGBHex(rgbValue) [UIColor \
colorWithRed:   ((CGFloat)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:          ((CGFloat)(((rgbValue) & 0xFF00) >> 8))/255.0 \
blue:           ((CGFloat) ((rgbValue) & 0xFF))/255.0 \
alpha:          1.0]

@interface UIColor (BTExtension)

/** 
 十六进制转化UIColor 
 */
+ (UIColor *)union_colorWithHexString:(NSString *)hexString;
+ (UIColor *)union_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 根据hex获取图片
 */
+ (UIColor *)union_colorWithHex:(NSUInteger)hex;

/**  
 rgb(255,255,255)  
 */
+ (UIColor *)union_colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue;

/**  
 颜色转化成UIImage 
 */
- (UIImage *)union_colorImage;
- (UIImage *)union_colorImageWithSize:(CGSize)specSize;
+ (UIColor *)un_colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;
@end
