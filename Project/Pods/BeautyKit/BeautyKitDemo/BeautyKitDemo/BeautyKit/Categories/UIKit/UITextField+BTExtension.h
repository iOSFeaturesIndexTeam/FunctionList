//
//  UITextField+BTExtension.h
//  BTExtension
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 BTExtension. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (BTExtension)

+ (UITextField *)union_blankSpaceTextField:(CGFloat)blankSpace;

+ (UITextField *)union_textFieldWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor placeholdColor:(UIColor *)placeholdColor;
- (void)configurePlaceholderLabelTextColor:(UIColor *)textColor;
- (void)configurePlaceholderLabelFont:(UIFont *)font;
@end
