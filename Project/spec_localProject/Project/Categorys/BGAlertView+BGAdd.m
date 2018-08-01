//
//  BGAlertView+BGAdd.m
//  BGAlertViewDemo
//
//  Created by Little.Daddly on 2018/6/19.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BGAlertView+BGAdd.h"
#import <UIColor+BTExtension.h>
#import <UIView+BTExtension.h>
@implementation BGAlertView (BGAdd)
+ (void)showAlertViewWithEditingChangedHandler:(void (^)(NSString *))editHandler actionTapedHandler:(void (^)(NSInteger))actionTapedHandler
{
    BGAlertView *view = [[BGAlertView alloc] initWithType:BGAlertViewTypeAlert];
    [self commonUpWith:view isLevel:NO editingChangedHandler:editHandler actionTapedHandler:actionTapedHandler];

   
}
+ (void)showSheetViewWithEditingChangedHandler:(void (^)(NSString *))editHandler actionTapedHandler:(void (^)(NSInteger))actionTapedHandler{
    BGAlertView *view = [[BGAlertView alloc] initWithType:BGAlertViewTypeSheet];
    [self commonUpWith:view isLevel:NO editingChangedHandler:editHandler actionTapedHandler:actionTapedHandler];
}

+ (void)showSheetViewLevelWithEditingChangedHandler:(void (^)(NSString *))editHandler actionTapedHandler:(void (^)(NSInteger))actionTapedHandler{
    BGAlertView *view = [[BGAlertView alloc] initWithType:BGAlertViewTypeSheet showType:BGAlertViewShowTypeLevel];
    [self commonUpWith:view isLevel:YES editingChangedHandler:editHandler actionTapedHandler:actionTapedHandler];
}

+ (void)commonUpWith:(BGAlertView *)view isLevel:(BOOL)isLevel editingChangedHandler:(void (^)(NSString *))editHandler actionTapedHandler:(void (^)(NSInteger))actionTapedHandler{
    CGFloat Vright_Lwidth = 0.f;
    if (isLevel) {
        Vright_Lwidth = -40;
    } else {
        Vright_Lwidth = 10;
    }
    view.maskKeyboard = NO;
    view.contentViewBottomKeyboardTop = 25.0f;
    view.paddingBot = 0;
    [view setupSubviewsWithHandler:^(UIView *contentView, UIImageView *backgroundView) {
        backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView union_addCornerRadius:15.0f];
    }];
    
    [view addTitleWithHandle:^(BGActionViewManager *action, UILabel *label) {
        //        action.size = 66.0f;
        action.bgEdge = BGEdgeMake(20, 20, -(Vright_Lwidth + 10), 40);
        label.text = @"确认收货人身份信息";
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.textColor = [UIColor union_colorWithHex:0x333333];
    }];
    
    [view addTextFieldWithHandler:^(BGActionViewManager *action, UITextField *textField) {
        //        action.size = 38.0f;
        action.bgEdge = BGEdgeMake(20, 10, -Vright_Lwidth, 30);
        //        BGEdgeMake(<#CGFloat top#>, <#CGFloat left#>, CGFloat Vright_Lwidth, <#CGFloat height#>)
        textField.placeholder = @"输入收货人姓名";
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0f, 0)];
        textField.backgroundColor = [UIColor union_colorWithHex:0xf0f0f0];
        textField.textColor = [UIColor union_colorWithHex:0x333333];
        textField.font = [UIFont systemFontOfSize:14.0f];
        [textField union_addCornerRadius:19.0f];
        [textField setValue:[UIColor union_colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
    } editingChangedHandler:editHandler];
    
    [view addTextFieldWithHandler:^(BGActionViewManager *action, UITextField *textField) {
        //        action.size = 38.0f;
        action.bgEdge = BGEdgeMake(20, 10, -Vright_Lwidth, 30);
        
        textField.placeholder = @"输入身份证号码";
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16.0f, 0)];
        textField.backgroundColor = [UIColor union_colorWithHex:0xf0f0f0];
        textField.textColor = [UIColor union_colorWithHex:0x333333];
        textField.font = [UIFont systemFontOfSize:14.0f];
        [textField union_addCornerRadius:19.0f];
        [textField setValue:[UIColor union_colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
    } editingChangedHandler:editHandler];
    
    [view addActionViewIsBTType:NO withHandle:^(BGActionViewManager *action, UIButton *button) {
        action.bgEdge = BGEdgeMake(20, 10, -10, 40);
        //        action.size = 39.0f;
        
        [button setTitle:@"确定" forState:0];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [button setTitleColor:[UIColor union_colorWithHex:0xffffff] forState:0];
        button.backgroundColor = [UIColor union_colorWithHex:0xe75887];
        [button union_addCornerRadius:19.5f];
    } tapedOnHandler:actionTapedHandler];
    
    [view addActionViewIsBTType:NO withHandle:^(BGActionViewManager *manager, UIButton *button) {
        manager.bgEdge = BGEdgeMake(20, 10, -10, 40);
        [button setTitle:@"取消" forState:0];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [button setTitleColor:[UIColor union_colorWithHex:0x999999] forState:0];
    } tapedOnHandler:actionTapedHandler];
    
    
    view.animationBeginHandler = ^(UIView *contentView, UIImageView *backgroundView, void (^completionHandler)(void)) {
        backgroundView.alpha = 0.0f;
        contentView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(backgroundView.frame) / 2);
        [UIView animateWithDuration:0.25f
                         animations:^{
                             contentView.transform = CGAffineTransformIdentity;
                             backgroundView.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             completionHandler();
                         }];
    };
    
        
    
    view.animationCompletionHandler = ^(UIView *contentView, UIImageView *backgroundView, void (^completionHandler)(void)) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(backgroundView.frame) / 2);
                             backgroundView.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             completionHandler();
                         }];
    };
    
    [view showAlertViewOnKeyWindow];
}

+ (void)titleTip:(NSString *)title{
    BGAlertView *view = [[BGAlertView alloc] initWithType:BGAlertViewTypeAlert];
    view.contentViewWidthRang = BGRangeMake(0, 300);
    view.contentViewHeightRang = BGRangeMake(0, 400);
    view.autoHideTimeInterval = 0.45;
    view.maskKeyboard = NO;
    view.paddingBot = 0;
    [view setupSubviewsWithHandler:^(UIView *contentView, UIImageView *backgroundView) {
        backgroundView.backgroundColor = [UIColor clearColor];
        contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        [contentView union_addCornerRadius:15.0f];
    }];
    CGFloat max_display_w = 300;
    CGFloat h = ceilf([title union_stringSizeWithFontSize:12 maxSize:CGSizeMake(max_display_w, MAXFLOAT)].height);
    [view addCustomViewWithHandler:^(BGActionViewManager *action, UIView *customView) {
        action.bgEdge = BGEdgeMake(0, 0, 0, 20 * 2 + h);
        customView.backgroundColor = [UIColor clearColor];
        [customView union_addCornerRadius:19.5];
        
        [UILabel lw_createView:^(__kindof UILabel *lb) {
            lb.numberOfLines = 0;
            lb.text = title;
            lb.backgroundColor = [UIColor clearColor];
            lb.textAlignment = NSTextAlignmentCenter;
            [customView addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }];
    }];
//    [view addActionViewIsBTType:NO withHandle:^(BGActionViewManager *action, UIButton *button) {
//        action.bgEdge = BGEdgeMake(0, 0, 0, 80);
//        //        action.size = 39.0f;
//        [button setTitle:title forState:0];
//        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
//        [button setTitleColor:[UIColor union_colorWithHex:0xffffff] forState:0];
//        button.backgroundColor = [UIColor clearColor];
//        [button union_addCornerRadius:19.5f];
//    } tapedOnHandler:nil];
    
    
    view.animationBeginHandler = ^(UIView *contentView, UIImageView *backgroundView, void (^completionHandler)(void)) {
        backgroundView.alpha = 0.0f;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             backgroundView.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             completionHandler();
                         }];
    };
    
    view.animationCompletionHandler = ^(UIView *contentView, UIImageView *backgroundView, void (^completionHandler)(void)) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             backgroundView.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             completionHandler();
                         }];
    };
    
    [view showAlertViewOnKeyWindow];
}
@end
