//
//  BTButton.m
//  BTkit
//
//  Created by BeautyHZ on 2017/8/25.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "BTButton.h"
#import <objc/runtime.h>

static void * union_alphaKey = &union_alphaKey; // 每个属性关联的关键字是唯一的 所以使用常量定义

@interface BTButton()

@property (nonatomic, assign) BOOL isNeedTitleAdjust;

@property (nonatomic, assign) BOOL isNeedImgAdjust;

@end

@implementation BTButton

- (void)setTitleRect:(CGRect)titleRect imgRect:(CGRect)imgRect {
    self.imgRect = imgRect;
    self.titleRect = titleRect;
}

- (void)setTitleRect:(CGRect)titleRect {
    _titleRect = titleRect;
    self.isNeedTitleAdjust = YES;
}

- (void)setImgRect:(CGRect)imgRect {
    _imgRect = imgRect;
    self.isNeedImgAdjust = YES;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return self.isNeedImgAdjust ? self.imgRect : [super imageRectForContentRect:contentRect];
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return self.isNeedTitleAdjust ? self.titleRect : [super imageRectForContentRect:contentRect];//文本的位置大小
}

- (void)setTouchDownAlpha:(CGFloat)touchDownAlpha {
    objc_setAssociatedObject(self, &union_alphaKey, @(touchDownAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)touchDownAlpha {
    id alpha = objc_getAssociatedObject(self, &union_alphaKey);
    return  [alpha doubleValue];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.alpha = 0.4f;
    return [super beginTrackingWithTouch:touch withEvent:event];
}


- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    self.alpha = 1.0f;
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    self.alpha = 1.0f;
    [super cancelTrackingWithEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    return YES;
}
@end
