//
//  UILabel+BTExtension.h
//  BeautyMall
//
//  Created by yaojc on 2017/5/26.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BTExtension)

+ (instancetype)union_labelWithFontSize:(NSInteger)size textColor:(UIColor *)textColor;

+ (UILabel *)union_labelWithTextColor:(UIColor *)color font:(CGFloat)font;
+ (UILabel *)union_labelWithTextColor:(UIColor *)color alpha:(CGFloat)alpha font:(CGFloat)font;

- (CGFloat)union_stringMaxWidth;

@end
