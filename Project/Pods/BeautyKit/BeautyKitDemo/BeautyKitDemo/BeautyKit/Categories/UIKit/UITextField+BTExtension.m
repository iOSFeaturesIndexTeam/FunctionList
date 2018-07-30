//
//  UITextField+BTExtension.m
//  BTExtension
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 BTExtension. All rights reserved.
//

#import "UITextField+BTExtension.h"

@implementation UITextField (BTExtension)

+ (UITextField *)union_blankSpaceTextField:(CGFloat)blankSpace {
    UITextField *view = [[UITextField alloc] init];
    view.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, blankSpace, 0)];
    view.leftViewMode = UITextFieldViewModeAlways;
    return view;
}

+ (UITextField *)union_textFieldWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor placeholdColor:(UIColor *)placeholdColor {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.tintColor = tintColor;
    [textField setValue:placeholdColor forKeyPath:@"_placeholderLabel.textColor"];
    return textField;
}
- (void)configurePlaceholderLabelTextColor:(UIColor *)textColor
{
    [self setValue:textColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)configurePlaceholderLabelFont:(UIFont *)font
{
    [self setValue:font forKeyPath:@"_placeholderLabel.font"];
}
@end
