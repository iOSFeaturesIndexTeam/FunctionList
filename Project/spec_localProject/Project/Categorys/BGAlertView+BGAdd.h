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
+ (void)showSheetViewWithEditingChangedHandler:(void (^)(NSString *))editHandler actionTapedHandler:(void (^)(NSInteger))actionTapedHandler;
+ (void)showSheetViewLevelWithEditingChangedHandler:(void (^)(NSString *))editHandler actionTapedHandler:(void (^)(NSInteger))actionTapedHandler;
@end
