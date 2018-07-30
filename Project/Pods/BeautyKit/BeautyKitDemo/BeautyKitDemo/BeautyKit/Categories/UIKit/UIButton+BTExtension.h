//
//  UIButton+BTExtension.h
//  BTkit
//
//  Created by BeautyHZ on 2017/8/25.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BTExtension)

/**
 初始化按钮
 */
+ (instancetype)union_buttonWithType:(UIButtonType)buttonType
                         normalImage:(NSString *)normalImage
                      highLightImage:(NSString *)highLightImage;

/**
 初始化按钮
 */
+ (instancetype)union_buttonWithType:(UIButtonType)buttonType title:(NSString *)title image:(NSString *)image;

/**
 设置按钮圆角+描边
 */
- (void)union_setCornerRadius:(CGFloat)cornerRadius borderWith:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


/**
 按钮图片在上文字在下布局

 @param buttonSize height=图片高度+文字高度+间距
 */
- (void)union_adjustTitleAndImagePostionWithButtonSize:(CGSize)buttonSize;

/**
 添加响应事件
 */
- (void)union_addAction:(void(^)(UIButton *sender))action;

@end
