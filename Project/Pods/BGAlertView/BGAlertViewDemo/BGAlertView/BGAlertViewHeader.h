//
//  BGAlertViewHeader.h
//  BGAlertViewDemo
//
//  Created by Little.Daddly on 2018/6/19.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#ifndef BGAlertViewHeader_h
#define BGAlertViewHeader_h
#import <UIKit/UIKit.h>
/**
 BGAlertView 内容视图样式
 
 - BGAlertViewStyleAlert: 默认居中-center
 - BGAlertViewStyleSheet: 紧贴left-right-bottom
 */
typedef NS_ENUM(NSUInteger,BGAlertViewType) {
    BGAlertViewTypeAlert = 0,
    BGAlertViewTypeSheet
};

/**
 上层视图的显示样式
 
 - BGAlertViewShowTypeLevel: 水平
 - BGAlertViewShowTypeVertical: 垂直
 */
typedef NS_ENUM(NSUInteger,BGAlertViewShowType) {
    BGAlertViewShowTypeLevel,
    BGAlertViewShowTypeVertical
};
typedef struct {
    CGFloat minimun;
    CGFloat maximun;
}BGRange;

static inline BGRange BGRangeMake(CGFloat minimun,CGFloat maximun){
    BGRange bg_rang;
    bg_rang.minimun = minimun;
    bg_rang.maximun = maximun;
    return bg_rang;
}
typedef struct {
    CGFloat top;
    CGFloat left;
    CGFloat Vright_Lwidth;
    CGFloat height;
} BGEdge;
static inline BGEdge BGEdgeMake(CGFloat top,CGFloat left,CGFloat Vright_Lwidth,CGFloat height){
    BGEdge bg_edge;
    bg_edge.top = top;
    bg_edge.left = left;
    bg_edge.Vright_Lwidth = Vright_Lwidth;
    bg_edge.height = height;
    return bg_edge;
}
/**
 内容响应视图 类型

 - BGAlertViewActionTypeUnknow: 未知类型
 - BGAlertViewActionTypeLabel: 文本
 - BGAlertViewActionTypeButton: 按钮
 - BGAlertViewActionTypeTextField: 输入框
 - BGAlertViewActionTypeImageView: 图片
 - BGAlertViewActionTypeCustomView:  自定义视图
 - BGAlertViewActionTypeAction: 选项视图
 */
typedef NS_ENUM(NSInteger,BGAlertViewActionType)
{
    BGAlertViewActionTypeUnknow = 0,
    BGAlertViewActionTypeLabel,
    BGAlertViewActionTypeButton,
    BGAlertViewActionTypeBTButton,
    BGAlertViewActionTypeTextField,
    BGAlertViewActionTypeImageView,
    BGAlertViewActionTypeCustomView,
    BGAlertViewActionTypeAction,
};

typedef void(^ BGAlertViewBtnHandler)(void);//按钮target 回调
typedef void(^ BGAlertViewActionHandler)(NSInteger index);//底部 响应视图回调
typedef void(^ BGAlertViewTextHandler)(NSString *string);//文本框回调
static NSString * const BGActionViewBeginAnimationCompletionNotification = @"BGActionViewBeginAnimationCompletionNotification";//开场动画结束通知
static NSString * const BGActionViewHandlerNotification = @"BGActionViewHandlerNotification";//内容视图 响应时间通知
#endif /* BGAlertViewHeader_h */
