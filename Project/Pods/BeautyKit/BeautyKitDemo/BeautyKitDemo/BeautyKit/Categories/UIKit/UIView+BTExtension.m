//  UIView+Extension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/4/28.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "UIView+BTExtension.h"
#import <objc/runtime.h>
#import "UIColor+BTExtension.h"
#import "UIViewController+BTExtension.h"

static NSInteger const union_topLineTag = 187777777;
static NSInteger const union_bottomLineTag = 188888888;

@implementation UIView (BTExtension)

- (void)setUnion_x:(CGFloat)union_x {
    CGRect frame = self.frame;
    frame.origin.x = union_x;
    self.frame = frame;
}

- (CGFloat)union_x {
    return self.frame.origin.x;
}

- (void)setUnion_y:(CGFloat)union_y {
    CGRect frame = self.frame;
    frame.origin.y = union_y;
    self.frame = frame;
}

- (CGFloat)union_y {
    return self.frame.origin.y;
}

- (void)setUnion_w:(CGFloat)union_w {
    CGRect frame = self.frame;
    frame.size.width = union_w;
    self.frame = frame;
}

- (CGFloat)union_w {
    return self.frame.size.width;
}

- (void)setUnion_h:(CGFloat)union_h {
    CGRect frame = self.frame;
    frame.size.height = union_h;
    self.frame = frame;
}

- (CGFloat)union_h {
    return self.frame.size.height;
}

- (void)setUnion_size:(CGSize)union_size {
    CGRect frame = self.frame;
    frame.size = union_size;
    self.frame = frame;
}

- (CGSize)union_size {
    return self.frame.size;
}

- (CGFloat)union_centerX {
    return self.center.x;
}

- (void)setUnion_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setUnion_origin:(CGPoint)union_origin {
    CGRect frame = self.frame;
    frame.origin = union_origin;
    self.frame = frame;
}

- (CGFloat)union_centerY {
    return self.center.y;
}

- (void)setUnion_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)union_origin {
    return self.frame.origin;
}

- (void)setUnion_right:(CGFloat)union_right {
    self.union_right = union_right;
}

- (CGFloat)union_right {
    return (self.frame.origin.x + self.frame.size.width);
}

- (void)setUnion_bottom:(CGFloat)union_bottom {
    CGRect frame = self.frame;
    frame.origin.y = union_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)union_bottom {
    return (self.frame.origin.y + self.frame.size.height);
}

- (UIImage *)union_snap {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *snapShot = UIGraphicsGetImageFromCurrentImageContext();
    return snapShot;
}

- (void)union_removeAllSubviews {
    NSMutableArray *subViews = [self.subviews mutableCopy];
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
}

- (void)union_insertTopLine {
    UIView *lineView = [[UIView alloc] init];
    [lineView setFrame:CGRectMake(0, 0, self.union_w, 0.5)];
    lineView.backgroundColor = [UIColor union_colorWithHexString:@"0xebebeb"];
    lineView.tag = union_topLineTag;
    [self addSubview:lineView];
}

- (void)union_insertBottomLine {
    UIView *lineView = [[UIView alloc] init];
    [lineView setFrame:CGRectMake(0, self.union_h - 0.5, self.union_w, 0.5)];
    lineView.backgroundColor = [UIColor union_colorWithHexString:@"0xebebeb"];
    lineView.tag = union_topLineTag;
    [self addSubview:lineView];
}

- (void)union_insertCellBottomLineWithRowHeight:(CGFloat)height {
    UIView *lineView = [[UIView alloc] init];
    [lineView setFrame:CGRectMake(0, height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor union_colorWithHexString:@"0xebebeb"];
    lineView.tag = union_bottomLineTag;
    [self addSubview:lineView];
}

- (void)union_removeTopLine {
    for (UIView *view in self.subviews) {
        if (view.tag == union_topLineTag) {
            [view removeFromSuperview];
        }
    }
}

- (void)union_removeBottomLine {
    for (UIView *view in self.subviews) {
        if (view.tag == union_bottomLineTag) {
            [view removeFromSuperview];
        }
    }
}

- (void)union_addShadow:(UIColor *)color offsetSize:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

+ (UIView *)union_topView {
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    return [UIViewController union_topViewControllerOnController:rootViewController].view;
}

- (void)union_addCornerRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    if (color) {
        self.layer.borderColor = color.CGColor;
    }
}

- (void)union_addCornerRadius:(CGFloat)radius {
    [self union_addCornerRadius:radius width:0.0f color:nil];
}

- (UIViewController *)union_topViewController {
    UIResponder *responder = self.nextResponder;
    do {
        if([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder != nil);
    return nil;
}

static char *kDTActionHandlerTapGestureKey;

- (void)union_insertTapActionWithHandler:(void (^)(void))handler {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, handler, OBJC_ASSOCIATION_RETAIN);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
        if (action) {
            action();
        }
    }
}

@end
