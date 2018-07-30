//
//  UIColor+BTExtension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/5.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "UIColor+BTExtension.h"

@implementation UIColor (BTExtension)

+ (UIColor *)union_colorWithHexString:(NSString *)hexString {
    return [self union_colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor *)union_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6){
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6){
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R
    NSString *rString = [cString substringWithRange:range];
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)union_colorWithHex:(NSUInteger)hex {
    CGFloat red, green, blue, alpha;
    
    red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
    green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
    blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
    alpha = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)union_colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue {
    return [UIColor colorWithRed:red/ 255.00f green:green/ 255.00f blue:blue/ 255.00f alpha:1.0f];
}

- (UIImage *)union_colorImage {
    return [self union_colorImageWithSize:CGSizeMake(1, 1)];
}

- (UIImage *)union_colorImageWithSize:(CGSize)specSize {
    CGRect rect = CGRectMake(0, 0, specSize.width, specSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIColor *)un_colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha
{
    return [[UIColor union_colorWithHex:hex] colorWithAlphaComponent:alpha];
}
@end
