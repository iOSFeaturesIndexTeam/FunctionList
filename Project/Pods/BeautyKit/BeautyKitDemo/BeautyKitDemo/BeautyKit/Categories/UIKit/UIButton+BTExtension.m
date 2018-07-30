//
//  UIButton+BTExtension.m
//  BTkit
//
//  Created by BeautyHZ on 2017/8/25.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "UIButton+BTExtension.h"
#import <objc/runtime.h>
#import "UIColor+BTExtension.h"


@implementation UIButton (BTExtension)

+ (instancetype)union_buttonWithType:(UIButtonType)buttonType
                         normalImage:(NSString *)normalImage
                      highLightImage:(NSString *)highLightImage {
    UIButton *button = [UIButton buttonWithType:buttonType];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highLightImage] forState:UIControlStateHighlighted];
    return button;
}

+ (instancetype)union_buttonWithType:(UIButtonType)buttonType
                               title:(NSString *)title
                               image:(NSString *)image {
    UIButton *button = [UIButton buttonWithType:buttonType];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return button;
}

- (void)union_setCornerRadius:(CGFloat)cornerRadius borderWith:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.clipsToBounds = YES;
}

- (void)union_adjustTitleAndImagePostionWithButtonSize:(CGSize)buttonSize {
    NSString *title = self.titleLabel.text;
    UIImage *image = self.imageView.image;
    CGFloat titleFont = self.titleLabel.font.pointSize;
    CGSize labelSize = [title
                        sizeWithAttributes:@{
                                             NSFontAttributeName:[UIFont systemFontOfSize:titleFont],
                                             }];
    CGFloat imageOffsetY = buttonSize.height - image.size.height;
    self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, 0, 0, 0);
    
    CGFloat imageWidth = image.size.width;
    CGFloat titileOffsetY = buttonSize.height - labelSize.height;
    //处理label宽度超过button宽度的问题
    CGFloat offsetX = 0;
    if (labelSize.width > buttonSize.width) {
        offsetX = labelSize.width - buttonSize.width;
    }
    self.titleEdgeInsets = UIEdgeInsetsMake(titileOffsetY, -imageWidth-offsetX, 0, -offsetX);
}

- (void)union_addAction:(void (^)(UIButton *))action {
    [self setUnion_action:action];
    [self addTarget:self action:@selector(union_click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)union_click:(UIButton *)sender {
    self.union_action(sender);
}

- (void(^)())union_action {
    return objc_getAssociatedObject(self, "BMButtonAction");
}

- (void)setUnion_action:(void(^)(UIButton *button))action {
    objc_setAssociatedObject(self, "BMButtonAction", action, OBJC_ASSOCIATION_RETAIN);
}

@end
