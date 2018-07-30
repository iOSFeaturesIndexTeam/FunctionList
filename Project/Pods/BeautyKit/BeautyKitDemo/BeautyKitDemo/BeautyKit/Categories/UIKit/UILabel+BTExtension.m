//
//  UILabel+BTExtension.m
//  BeautyMall
//
//  Created by yaojc on 2017/5/26.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "UILabel+BTExtension.h"
#import "NSString+BTExtension.h"
#import "UIColor+BTExtension.h"
#import "UIView+BTExtension.h"

@implementation UILabel (BTExtension)

+ (instancetype)union_labelWithFontSize:(NSInteger)size textColor:(UIColor *)textColor{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = textColor;
    label.numberOfLines = 0;
    return label;
}

+ (UILabel *)union_labelWithTextColor:(UIColor *)color font:(CGFloat)font {
    UILabel *label = [[UILabel alloc] init];
    if (color) {
        label.textColor = color;
    }
    if (font) {
        label.font = [UIFont systemFontOfSize:font];
    }
    return label;
}

+ (UILabel *)union_labelWithTextColor:(UIColor *)color alpha:(CGFloat)alpha font:(CGFloat)font {
    return [self union_labelWithTextColor:[color colorWithAlphaComponent:alpha] font:font];
}

- (CGFloat)union_stringMaxWidth {
    return [self.text union_stringSizeWithFont:self.font maxSize:CGSizeMake(MAXFLOAT, self.union_h)].width;
}

@end
