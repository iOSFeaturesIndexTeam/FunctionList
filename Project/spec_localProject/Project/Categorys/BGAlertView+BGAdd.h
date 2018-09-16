//
//  BGAlertView+BGAdd.h
//  BGAlertViewDemo
//
//  Created by Little.Daddly on 2018/6/19.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BGAlertView.h"

@interface BGAlertView (BGAdd)
/**
 输入框
 包含一个标题
 包含两个输入框,一个姓名,一个身份证
 包含确认、取消
 */
+ (void)showAlertViewWithEditingChangedHandler:(void(^)(NSString *string))editHandler
                            actionTapedHandler:(void(^)(NSInteger index))actionTapedHandler;

+ (void)showSheetViewWithEditingChangedHandler:(void (^)(NSString *))editHandler
                            actionTapedHandler:(void (^)(NSInteger))actionTapedHandler;

+ (void)showSheetViewLevelWithEditingChangedHandler:(void (^)(NSString *))editHandler
                                 actionTapedHandler:(void (^)(NSInteger))actionTapedHandler;


/**
 自动隐藏 文本提示窗
 换行 请 加入\n 自动适配 提示宽度
 
 @param title 提示
 */
+ (void)titleTip:(NSString *)title;
/** title + 水平按钮左右按钮 */
+ (void)normalAlertWithTitle:(NSString *)title subBtnTitle:(NSArray *)btnTitles actionTapedHandler:(void(^)(NSInteger index))actionTapedHandler;;
@end
