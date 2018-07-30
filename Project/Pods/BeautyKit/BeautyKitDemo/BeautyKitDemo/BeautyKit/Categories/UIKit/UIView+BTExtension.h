//  UIView+Extension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/4/28.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BTExtension)
@property (assign, nonatomic) CGFloat union_x;
@property (assign, nonatomic) CGFloat union_y;
@property (assign, nonatomic) CGFloat union_w;
@property (assign, nonatomic) CGFloat union_h;
@property (assign, nonatomic) CGSize union_size;
@property (assign, nonatomic) CGPoint union_origin;
@property (assign, nonatomic) CGFloat union_right;
@property (assign, nonatomic) CGFloat union_bottom;
@property (assign, nonatomic) CGFloat union_centerX;
@property (assign, nonatomic) CGFloat union_centerY;

/**
 截图
 */
- (UIImage *)union_snap;

/** 
 移除全部子视图 
 */
- (void)union_removeAllSubviews;

/**
 获取最顶层控制器的视图
 */
+ (UIView *)union_topView;

/* 
 视图顶部加线
 */
- (void)union_insertTopLine;

/*
 去视图顶部线
 */
- (void)union_removeTopLine;

/*
 去视图底部线
 */
- (void)union_removeBottomLine;

/*
 视图底部加线 
 */
- (void)union_insertBottomLine;

/* 
 视图底部加线 
 */
- (void)union_insertCellBottomLineWithRowHeight:(CGFloat)height;

/**
 添加角标
 */
- (void)union_addCornerRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color;
- (void)union_addCornerRadius:(CGFloat)radius;

/**
 添加阴影
 */
- (void)union_addShadow:(UIColor *)color offsetSize:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;

/**
 获取当前的顶层控制器
 */
- (UIViewController *)union_topViewController;

/**
 添加手势方法
 */
- (void)union_insertTapActionWithHandler:(void (^)(void))handler;

@end
