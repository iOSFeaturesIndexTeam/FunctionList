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
    
    CGSize size = [title union_stringSizeWithFontSize:12
                                              maxSize:CGSizeMake(
                                                                 MAXFLOAT,
                                                                 MAXFLOAT
                                                                 )];
    CGFloat h = ceilf(size.height);
    CGFloat w = ceilf(size.width);
    CGFloat padding_top = 20.;
    BGAlertView *view = [[BGAlertView alloc] initWithType:BGAlertViewTypeAlert];
    view.contentViewWidthRang = BGRangeMake(0, w + padding_top * 2);
    view.contentViewHeightRang = BGRangeMake(0, h + padding_top * 2);
    view.autoHideTimeInterval = 0.45f;
    view.maskKeyboard = NO;
    view.paddingBot = 0;
    [view setupSubviewsWithHandler:^(UIView *contentView, UIImageView *backgroundView) {
        backgroundView.backgroundColor = [UIColor clearColor];
        contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        [contentView union_addCornerRadius:15.0f];
    }];
    
    [view addCustomViewWithHandler:^(BGActionViewManager *action, UIView *customView) {
        action.bgEdge = BGEdgeMake(0, 0, 0, padding_top * 2 + h);
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

+ (void)normalAlertWithTitle:(NSString *)title subBtnTitle:(NSArray *)btnTitles actionTapedHandler:(void(^)(NSInteger index))actionTapedHandler{
    BGAlertView *view = [[BGAlertView alloc] initWithType:BGAlertViewTypeAlert];
    view.actionViewShowType = BGAlertViewShowTypeLevel;
    view.contentViewWidthRang = BGRangeMake(270, 300);
    view.contentViewHeightRang = BGRangeMake(120, 150);
    view.maskKeyboard = NO;
    view.contentViewBottomKeyboardTop = 25.0f;
    view.paddingBot = 0;
    [view setupSubviewsWithHandler:^(UIView *contentView, UIImageView *backgroundView) {
        backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView union_addCornerRadius:15.0f];
    }];
    
    [view addTitleWithHandle:^(BGActionViewManager *action, UILabel *label) {
        action.bgEdge = BGEdgeMake(30, 20, 0, 40);
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.textColor = [UIColor union_colorWithHex:0x333333];
    }];
    
   
    [view addActionViewIsBTType:NO withHandle:^(BGActionViewManager *action, UIButton *button) {
        action.bgEdge = BGEdgeMake(80, 20, 100, 40);
        [button setTitle:btnTitles.firstObject forState:0];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [button setTitleColor:[UIColor union_colorWithHex:0xffffff] forState:0];
        button.backgroundColor = [UIColor union_colorWithHex:0xe75887];
        [button union_addCornerRadius:19.5f];
    } tapedOnHandler:actionTapedHandler];
    
    [view addActionViewIsBTType:NO withHandle:^(BGActionViewManager *manager, UIButton *button) {
        manager.bgEdge = BGEdgeMake(80, 30, 100, 40);
        [button setTitle:btnTitles.lastObject forState:0];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        [button union_addCornerRadius:19.5f];
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
+ (void)alertTitle:(NSString *)title actionTitles:(NSArray *)titles actionTapedHandler:(void(^)(NSInteger index))actionTapedHandler closeOption:(void (^)())option{
    
    CGFloat Vright_Lwidth = -10.f;
    BGAlertView *view = [[BGAlertView alloc] initWithType:BGAlertViewTypeAlert];
    view.contentViewHeightRang = BGRangeMake(85 * titles.count, 85 * titles.count + 40);
    view.isAlwaysVisible = YES;
    view.maskKeyboard = NO;
    view.contentViewBottomKeyboardTop = 25.0f;
    view.paddingBot = 0;
    @weakify(view)
    [view setupSubviewsWithHandler:^(UIView *contentView, UIImageView *backgroundView) {
        backgroundView.backgroundColor = [UIColor clearColor];
        [contentView union_addCornerRadius:15.0f];
        
        @strongify(view)
        contentView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [view closeAlertView];
            if (option) {
                option();
            }
        }];
        [backgroundView addGestureRecognizer:tap];
        
    }];
    
    
    [view addTitleWithHandle:^(BGActionViewManager *action, UILabel *label) {
        //        action.size = 66.0f;
        action.bgEdge = BGEdgeMake(20, 20, -(Vright_Lwidth + 10), 40);
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.textColor = [UIColor union_colorWithHex:0x333333];
    }];
    
    [titles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [view addActionViewIsBTType:NO withHandle:^(BGActionViewManager *action, UIButton *button) {
            action.bgEdge = BGEdgeMake(20, 10, -10, 40);
            
            [button setTitle:obj forState:0];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
            [button setTitleColor:[UIColor union_colorWithHex:0xffffff] forState:0];
            button.backgroundColor = [UIColor union_colorWithHex:0xe75887];
            [button union_addCornerRadius:19.5f];
        } tapedOnHandler:actionTapedHandler];
    }];
    
    
    
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
@end
