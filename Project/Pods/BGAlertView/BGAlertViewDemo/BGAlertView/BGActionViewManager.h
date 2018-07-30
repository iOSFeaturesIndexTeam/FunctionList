//
//  BGActionViewManager.h
//  BGAlertViewDemo
//
//  Created by Little.Daddly on 2018/6/19.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGAlertViewHeader.h"
@class BGAlertView;
@interface BGActionViewManager : NSObject
- (instancetype)initWithAlertView:(BGAlertView *)alertView
                             type:(BGAlertViewActionType)type;

@property (nonatomic,readonly) BGAlertViewActionType type;
@property (nonatomic,strong,readonly) UILabel *label;
@property (nonatomic,strong,readonly) UIButton *button;
@property (nonatomic,strong,readonly) UITextField *textField;
@property (nonatomic,strong,readonly) UIImageView *imageView;
@property (nonatomic,strong,readonly) UIView *customView;

@property (nonatomic,assign) NSUInteger index;//唯一标识 
@property (nonatomic) CGFloat width;
/** 内边距 */
@property (nonatomic) BGEdge bgEdge;
@property (nonatomic,copy) BGAlertViewBtnHandler btnHandle;
@property (nonatomic,copy) BGAlertViewActionHandler actionHandler;
@property (nonatomic,copy) BGAlertViewTextHandler textHandler;
- (void)replaceCustomView:(UIView *)customView;
@end
