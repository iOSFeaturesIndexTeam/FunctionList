//
//  BGActionViewManager.m
//  BGAlertViewDemo
//
//  Created by Little.Daddly on 2018/6/19.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BGActionViewManager.h"
#import "UIView+BTExtension.h"
#import "UIView+LW_BlockCreate.h"
#import "BeautyKitMacro.h"
#import "Masonry.h"
#import "BTButton.h"
#import "BGAlertView.h"
@interface BGActionViewManager(){
    CGFloat _innerSize;
}
@property (nonatomic,weak) BGAlertView *alertView;
@end
@implementation BGActionViewManager
- (instancetype)initWithAlertView:(BGAlertView *)alertView type:(BGAlertViewActionType)type{
    self = [super init];
    if (!self) { return nil;}
    
    _alertView = alertView;
    _type = type;
    _bgEdge = BGEdgeMake(0, 0, 0, 0);
    switch (type) {
        case BGAlertViewActionTypeUnknow:
            _innerSize = 0;
            break;
        case BGAlertViewActionTypeLabel:
            _label = [UILabel lw_createView:^(__kindof UILabel *lb) {
                lb.textAlignment = NSTextAlignmentCenter;
                lb.numberOfLines = 0;
            }];
            break;
        case BGAlertViewActionTypeButton:{
            _innerSize = 45.0f;
            _button = [UIButton lw_createView:^(__kindof UIButton *btn) {
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15.]];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
            break;
        case BGAlertViewActionTypeBTButton:{
            _innerSize = 45.0f;
            _button = [BTButton lw_createView:^(__kindof BTButton *btn) {
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15.]];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
        case BGAlertViewActionTypeImageView:{
            _imageView = [UIImageView new];
            _innerSize = 30.0f;
        }
            break;
        case BGAlertViewActionTypeTextField:{
            _textField = [UITextField lw_createView:^(__kindof UITextField *textFiled) {
                [textFiled addTarget:self action:@selector(textFieldEditingChangedAction:) forControlEvents:UIControlEventEditingChanged];
            }];
            _innerSize = 50.0f;
        }
            break;
        case BGAlertViewActionTypeCustomView:{
            _customView = [UIView new];
            _innerSize = 50.0f;
        }
            break;
        case BGAlertViewActionTypeAction:{
            _innerSize = 45.0f;
            _button = [UIButton lw_createView:^(__kindof UIButton *btn) {
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(alertBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
            break;
        default:
            break;
    }
    return self;
}

#pragma mark - Action
- (void)alertBtnAction:(UIButton *)sender{
    if (self.actionHandler) {
        self.actionHandler(_index);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BGActionViewHandlerNotification object:nil userInfo:@{@"hash":@(_alertView.hash)}];
}
- (void)btnAction:(BTButton *)sender{
    if (self.btnHandle) {
        self.btnHandle();
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:BGActionViewHandlerNotification object:nil userInfo:@{@"hash":@(_alertView.hash)}];
}
- (void)textFieldEditingChangedAction:(UITextField *)textField{
    if (self.textHandler) {
        self.textHandler(textField.text);
    }
    
}
#pragma mark - Getter&Setter
- (CGFloat)width{
    if (_width == 0.f) {
        return _innerSize;
    }
    return _width;
}
- (void)replaceCustomView:(UIView *)customView{
    _customView = customView;
}
@end
