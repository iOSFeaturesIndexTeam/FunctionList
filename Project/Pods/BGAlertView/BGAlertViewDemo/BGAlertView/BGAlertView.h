//
//  BGAlertView.h
//  BGAlertViewDemo
//
//  Created by Little.Daddly on 2018/6/19.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGActionViewManager.h"
#import "BGAlertViewHeader.h"
@class BTButton;
@interface BGAlertView : UIView
- (instancetype)initWithType:(BGAlertViewType)type;
- (instancetype)initWithType:(BGAlertViewType)type
                    showType:(BGAlertViewShowType)showType;
/** 弹框样式 */
@property (nonatomic,assign,readonly) BGAlertViewType type;
/** 弹窗响应视图的展示样式 上层内容 */
@property (nonatomic,assign,readonly) BGAlertViewShowType contentViewShowType;
/** 弹窗响应视图的展示样式 底部的响应按钮 【暂时不支持 水平 样式】*/
@property (nonatomic,assign) BGAlertViewShowType actionViewShowType;
/** 是否一直可见 */
@property (nonatomic) BOOL isAlwaysVisible;
/** 单机alertView 关闭弹窗 */
@property (nonatomic,assign,getter=isTapAlertViewClose) BOOL tapAlertViewClose;
/** alertView 内容视图的内边距设置 */
//@property (nonatomic,assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic,copy) void(^tapAlertViewHandle)(void);
/** 单机AlertView关闭第一响应者,默认 YES */
@property (nonatomic,assign,getter=isTapAlertViewEndEidt) BOOL tapAlertViewEndEidt;
/** 弹窗是否遮罩键盘 默认 YES*/
@property (nonatomic,assign,getter=isMaskKeyboard) BOOL maskKeyboard;
/** 弹窗内容 相对键盘 间距 */
@property (nonatomic,assign) CGFloat contentViewBottomKeyboardTop;
/** 自动消失时长 默认是 0 则不主动消失*/
@property (nonatomic,assign) NSTimeInterval autoHideTimeInterval;
/** 是否允许内容视图的手势事件 */
@property (nonatomic,assign) BOOL enableContenViewGesture;
/** 内容底部外边距 */
@property (nonatomic,assign) CGFloat paddingBot;
/** 动画回调 */
@property (nonatomic,copy) void(^ animationBeginHandler)(UIView *contentView, UIImageView *backgroundView,void(^ completionHandler)(void)); //开场动画
@property (nonatomic,copy) void(^ animationCompletionHandler)(UIView *contentView, UIImageView *backgroundView, void(^ completionHandler)(void)); // 结束动画
@property (nonatomic,assign) BGRange contentViewWidthRang;
@property (nonatomic,assign) BGRange contentViewHeightRang;
/** 配置内部显示父视图、背景视图 */
- (void)setupSubviewsWithHandler:(void(^)(UIView *contentView, UIImageView *backgroundView))handler;
/**
 添加内容视图按钮

 @param isBTType 是否为BT样式
 @param handler 按钮配置
 @param tapedOnHandler 触发事件回调
 */
- (void)addButtonIsBTType:(BOOL)isBTType
              withHandler:(void(^)(BGActionViewManager *manager, UIButton *btn))handler
              tapedOnHandler:(void(^)(void))tapedOnHandler;
/**
 添加内容视图 标题

 @param handler 配置标题管理者
 */
- (void)addTitleWithHandle:(void(^)(BGActionViewManager *manager,UILabel *lb))handler;
/**
 添加内容视图 图标

 @param handler 配置图标管理者
 */
- (void)addIconWithHandler:(void(^)(BGActionViewManager *action, UIImageView *imageView))handler;
/**
 添加内容视图 输入框

 @param handler 配置输入框管理者
 @param editHandler 编辑回调
 */
- (void)addTextFieldWithHandler:(void(^)(BGActionViewManager *action, UITextField *textField))handler
          editingChangedHandler:(void(^)(NSString *string))editHandler;

/**
 添加内容视图底部 响应视图
 
 @param isBTType 按钮样式
 @param handler 响应视图配置回调
 @param tapedOnHandler 响应事件回调
 */
- (void)addActionViewIsBTType:(BOOL)isBTType
                   withHandle:(void(^)(BGActionViewManager *manager,UIButton *btn))handler
               tapedOnHandler:(void(^)(NSInteger tapIndex))tapedOnHandler;
/**
 添加内容视图 自定义视图

 @param handler 自定义视图管理者
 */
- (void)addCustomViewWithHandler:(void(^)(BGActionViewManager *action, UIView *customView))handler;

/** 展示视图 */
- (void)showAlertView;
- (void)showAlertViewOnKeyWindow;
- (void)showAlertViewOnKeyboardWindow;
/** 回收视图 */
- (void)closeAlertView;
@end
