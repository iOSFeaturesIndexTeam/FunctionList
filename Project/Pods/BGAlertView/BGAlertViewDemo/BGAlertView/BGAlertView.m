//
//  BGAlertView.m
//  BGAlertViewDemo
//
//  Created by Little.Daddly on 2018/6/19.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BGAlertView.h"
#import "UIView+BTExtension.h"
//#import <BeautyKit/UIView+BTExtension.h>
#import "UIView+LW_BlockCreate.h"
#import "BeautyKitMacro.h"
#import "Masonry.h"
#import "BTButton.h"
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")
@interface BGAlertView(){
    NSMutableArray *_innerViews;//上层视图栈
    NSMutableArray *_innerActions;//响应者视图栈
    
    UIScrollView *_scrollView;
    UIView *_scr_contentView;
    UIView *_contentView;
    UIImageView *_backgroundView;
}
@property (nonatomic,strong) NSTimer *autoHideTimer;
@end

@implementation BGAlertView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_autoHideTimer invalidate];
    _autoHideTimer = nil;
    KCLog(@"dalloc ---- %@",NSStringFromClass([self class]));
}
- (instancetype)initWithType:(BGAlertViewType)type{
    return [self initWithType:type showType:BGAlertViewShowTypeVertical];
}

- (instancetype)initWithType:(BGAlertViewType)type showType:(BGAlertViewShowType)showType{
    self = [super init];
    if (!self) {return nil;}
    
    _type = type;
    _contentViewShowType = showType;
    
    _actionViewShowType = BGAlertViewShowTypeVertical;
    _innerViews = [NSMutableArray new];
    _innerActions = [NSMutableArray new];
    
    _isAlwaysVisible = NO;
    _enableContenViewGesture = YES;
    _maskKeyboard = YES;
    _tapAlertViewClose = YES;
    _tapAlertViewEndEidt = YES;
    _paddingBot = 15.f;
    _contentViewWidthRang = BGRangeMake(0, 280);
    _contentViewHeightRang = BGRangeMake(0, 500);
    _backgroundView = [UIImageView lw_createView:^(UIImageView *bgView) {
        bgView.backgroundColor = [UIColor clearColor];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedOnAction:)];
        [bgView addGestureRecognizer:tap];
    }];
    
    _contentView = [UIView lw_createView:^(__kindof UIView *v) {
        v.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapedOnAction:)];
        [v addGestureRecognizer:tap];
        [self addSubview:v];
    }];
    
    _scrollView = [UIScrollView lw_createView:^(__kindof UIScrollView *scroV) {
        scroV.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:scroV];
    }];
    _scr_contentView = [UIView lw_createView:^(__kindof UIView *v) {
        [_scrollView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.height.equalTo(_scrollView);
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionHandlerNotification:) name:BGActionViewHandlerNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aniBeginCompletion:) name:BGActionViewBeginAnimationCompletionNotification object:nil];
    return self;
}

#pragma mark - Notification
//- (void)aniBeginCompletion:(NSNotification *)noit{
//    _isAlwaysVisible = NO;
//}
- (void)keyboardWillHideNotification:(NSNotification *)noti{
    _contentView.transform = CGAffineTransformIdentity;
    [_contentView endEditing:YES];
}
- (void)keyboardWillShowNotification:(NSNotification *)noti{
    CGRect keyboardRect = [[[noti userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!CGAffineTransformIsIdentity(_contentView.transform)) {
        return;
    }
    if (self.isMaskKeyboard) {
        UIView *firstResponder = [self searchFirstResponder];
        CGRect responderRect = [self convertRect:firstResponder.frame fromView:_contentView];
        CGFloat responderMaxy = CGRectGetMaxY(responderRect) - _scrollView.contentOffset.y;
        if (responderMaxy < (self.union_h - CGRectGetHeight(keyboardRect)))
        {
        } else {//弹窗视图 被 键盘 遮罩的时候 适当上移
            CGFloat y = CGRectGetHeight(self.frame) - CGRectGetHeight(keyboardRect) - CGRectGetHeight(responderRect);
            CGFloat ty = y - (responderMaxy - CGRectGetHeight(responderRect)) + _contentView.transform.ty;
            _contentView.transform = CGAffineTransformMakeTranslation(0, ty);
        }
    } else { //不遮挡 键盘
        if (_contentViewBottomKeyboardTop > 0) {
            CGFloat contentViewMaxy = CGRectGetMaxY(_contentView.frame);
            CGFloat keyboardMaxHeight = (CGRectGetHeight(self.frame) - CGRectGetHeight(keyboardRect));
            
            CGFloat aimedMaxy = contentViewMaxy + _contentViewBottomKeyboardTop;
            CGFloat ty = keyboardMaxHeight - aimedMaxy;
            
            _contentView.transform = CGAffineTransformMakeTranslation(0, ty);
        }
    }
    
}
- (void)actionHandlerNotification:(NSNotification *)noti{
    if ([noti.userInfo.allKeys containsObject:@"hash"]) {
        NSUInteger hash = [[noti.userInfo objectForKey:@"hash"] integerValue];
        if (hash == self.hash) {
            [self closeAnimation];
        }
    }
}

- (void)setupSubviewsWithHandler:(void(^)(UIView *contentView, UIImageView *backgroundView))handler{
    if (handler) {
        handler(_contentView,_backgroundView);
    }
}

- (void)addTitleWithHandle:(void (^)(BGActionViewManager *, UILabel *))handler{
    if (handler) {
        BGActionViewManager *manager = [[BGActionViewManager alloc] initWithAlertView:self type:BGAlertViewActionTypeLabel];
        handler(manager,manager.label);
        [_innerViews addObject:manager];
    }
}
- (void)addIconWithHandler:(void (^)(BGActionViewManager *, UIImageView *))handler{
    if (handler) {
        BGActionViewManager *manager = [[BGActionViewManager alloc] initWithAlertView:self type:BGAlertViewActionTypeImageView];
        handler(manager,manager.imageView);
        [_innerViews addObject:manager];
    }
}

- (void)addTextFieldWithHandler:(void (^)(BGActionViewManager *, UITextField *))handler editingChangedHandler:(void (^)(NSString *))editHandler{
    if (handler) {
        BGActionViewManager *manager = [[BGActionViewManager alloc] initWithAlertView:self type:BGAlertViewActionTypeTextField];
        manager.textHandler = editHandler;
        handler(manager,manager.textField);
        [_innerViews addObject:manager];
    }
}
- (void)addButtonIsBTType:(BOOL)isBTType
              withHandler:(void(^)(BGActionViewManager *manager, UIButton *btn))handler
           tapedOnHandler:(void(^)(void))tapedOnHandler{
    if (handler) {
        BGActionViewManager *manager = [[BGActionViewManager alloc] initWithAlertView:self type:isBTType?BGAlertViewActionTypeBTButton: BGAlertViewActionTypeButton];
        manager.btnHandle = tapedOnHandler;
        handler(manager,manager.button);
    }
}
- (void)addCustomViewWithHandler:(void (^)(BGActionViewManager *, UIView *))handler{
    if (handler) {
        BGActionViewManager *manager = [[BGActionViewManager alloc] initWithAlertView:self type:BGAlertViewActionTypeCustomView];
        handler(manager,manager.customView);
        [_innerViews addObject:manager];
    }
}

- (void)addActionViewIsBTType:(BOOL)isBTType
                   withHandle:(void(^)(BGActionViewManager *manager,UIButton *btn))handler
               tapedOnHandler:(void(^)(NSInteger tapIndex))tapedOnHandler{
    if (handler) {
        BGActionViewManager *manager = [[BGActionViewManager alloc] initWithAlertView:self type:isBTType?BGAlertViewActionTypeBTButton: BGAlertViewActionTypeAction];
        manager.actionHandler = tapedOnHandler;
        handler(manager,manager.button);
        [_innerActions addObject:manager];
    }
}

- (void)showAlertViewOnKeyboardWindow
{
    UIView *showView = nil;
    for (UIView *window in [UIApplication sharedApplication].windows)
    {
        if( [window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")] )
        {
            showView = window;
            break;
        }
    }
    
    if (showView == nil)
    {
        showView = [UIApplication sharedApplication].keyWindow;
    }
    
    [showView addSubview:self];
    self.frame = showView.bounds;
    [self showAlertView];
}

- (void)showAlertViewOnKeyWindow
{
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.frame = keyWindow.bounds;
    [self showAlertView];
}

- (void)showAlertView{
    __block UIView *prefixView = nil;
    
    [_innerViews enumerateObjectsUsingBlock:^(BGActionViewManager *manager, NSUInteger idx, BOOL * _Nonnull stop) {
        BGAlertViewActionType type = manager.type;
        UIView *view = [self actionViewInManager:manager];
    
        if (type != BGAlertViewActionTypeUnknow) {
        
            if (view) {
                [_scr_contentView addSubview:view];
                
                if (_contentViewShowType == BGAlertViewShowTypeVertical) {
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (!prefixView) {//头一个
                            make.top.mas_equalTo(manager.bgEdge.top);
                        } else {
                        make.top.equalTo(prefixView.mas_bottom).offset(manager.bgEdge.top);
                        }
                        
                        make.left.mas_equalTo(manager.bgEdge.left);
                        make.right.mas_equalTo(manager.bgEdge.Vright_Lwidth).priorityHigh();
                        make.height.mas_equalTo(manager.bgEdge.height);

                    }];
                } else if (_contentViewShowType == BGAlertViewShowTypeLevel){
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (!prefixView) {
                            make.left.mas_equalTo(manager.bgEdge.left);
                        } else {
                            make.left.equalTo(prefixView.mas_right).offset(manager.bgEdge.left);
                        }
                        make.top.mas_equalTo(manager.bgEdge.top);
                        make.height.mas_equalTo(manager.bgEdge.height);
                        make.width.mas_equalTo(manager.bgEdge.Vright_Lwidth);
                    }];
                }
                
                prefixView = view;
            }
        }
    }];
    //更新scroview
    [_scrollView layoutIfNeeded];
    [_scr_contentView layoutIfNeeded];
    
    __block CGFloat max_h_level = 0.f;
    if (_contentViewShowType == BGAlertViewShowTypeVertical) {
        max_h_level = CGRectGetMaxY(prefixView.frame);
    } else if (_contentViewShowType == BGAlertViewShowTypeLevel){
        [_innerViews enumerateObjectsUsingBlock:^(BGActionViewManager *manager, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *view = [self actionViewInManager:manager];
            if (CGRectGetMaxY(view.frame) > max_h_level) {
                max_h_level = CGRectGetMaxY(view.frame);
            }
        }];
    }
    
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.width.equalTo(_contentView);
        make.height.mas_equalTo(max_h_level);
    }];
    
//    _scrollView.contentSize = _scrollView.union_size;
    
    //添加底部 响应事件 视图
    __block UIView *innerActionPrefixView = nil;
    [_innerActions enumerateObjectsUsingBlock:^(BGActionViewManager *manager, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [self actionViewInManager:manager];
        
        if (manager.type != BGAlertViewActionTypeUnknow) {
            if (view) {
                [_contentView addSubview:view];
                manager.index = 1000+idx;
                if (_actionViewShowType == BGAlertViewShowTypeVertical) {
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (!innerActionPrefixView) {
                            make.top.equalTo(_scrollView.mas_bottom).offset(manager.bgEdge.top);
                        } else {
                            make.top.equalTo(innerActionPrefixView.mas_bottom).offset(manager.bgEdge.top);
                        }
                        make.left.mas_equalTo(manager.bgEdge.left);
                        make.right.mas_equalTo(manager.bgEdge.Vright_Lwidth).priorityHigh();
                        make.height.mas_equalTo(manager.bgEdge.height);
                    }];
                } else if (_actionViewShowType == BGAlertViewShowTypeLevel) {
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (!innerActionPrefixView) {
                            make.left.mas_equalTo(manager.bgEdge.left);
                        } else {
                            make.left.equalTo(innerActionPrefixView.mas_right).offset(manager.bgEdge.left);
                            
                        }
                        make.top.mas_equalTo(manager.bgEdge.top);
                        make.width.mas_equalTo(manager.bgEdge.Vright_Lwidth);
                        make.height.mas_equalTo(manager.bgEdge.height);
                    }];
                }
                
                innerActionPrefixView = view;
            }
        }
    }];
    
    //更新 contentView
    [_contentView layoutIfNeeded];
    if (_actionViewShowType == BGAlertViewShowTypeVertical) {
        CGFloat max_innerView_h = CGRectGetMaxY(innerActionPrefixView.frame) + _paddingBot;
        if (!innerActionPrefixView) {
            max_innerView_h = CGRectGetMaxY(_scrollView.frame);
        }
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_type == BGAlertViewTypeSheet) {
                make.left.right.bottom.mas_equalTo(0);
            } else {
                make.center.mas_equalTo(0);
                make.width.mas_equalTo(_contentViewWidthRang.maximun);
            }
            
            CGFloat height = 0.f;
            height = _contentViewHeightRang.maximun > max_innerView_h ? max_innerView_h : _contentViewHeightRang.maximun;
            if (_contentViewHeightRang.minimun > max_innerView_h) {
                height = _contentViewHeightRang.minimun;
            }
            make.height.mas_equalTo(height);
            
        }];
    } else if (_actionViewShowType == BGAlertViewShowTypeLevel) {
        CGFloat max_innerView_w = CGRectGetMaxX(innerActionPrefixView.frame) + _paddingBot;
        if (!innerActionPrefixView) {
            max_innerView_w = CGRectGetMaxY(_scrollView.frame);
        }
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_type == BGAlertViewTypeSheet) {
                make.left.right.bottom.mas_equalTo(0);
            } else {
                make.center.mas_equalTo(0);
                CGFloat width = 0.f;
                width =  _contentViewWidthRang.maximun > max_innerView_w ? max_innerView_w : _contentViewWidthRang.maximun;
                if (_contentViewWidthRang.minimun > max_innerView_w) {
                    width = _contentViewWidthRang.minimun;
                }
                make.width.mas_equalTo(width);
            }
            
            make.height.mas_equalTo(_contentViewHeightRang.maximun);
        }];
    }
   /** 展示动画 */
    [self layoutIfNeeded];
    [self setupAnimation];
    [self autoHideTimer];
}
#pragma mark - Custom Method
- (void)setupAnimation{
    BOOL temp = _isAlwaysVisible;
    if (self.animationBeginHandler) {
        __weak typeof(self) weakSelf = self;
        self.animationBeginHandler(_contentView, _backgroundView, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.isAlwaysVisible = temp;
        });
    }
    _isAlwaysVisible = YES;
}
- (UIView *)actionViewInManager:(BGActionViewManager *)manager
{
    switch (manager.type)
    {
        case BGAlertViewActionTypeUnknow:
        {
            return nil;
        }
            break;
        case BGAlertViewActionTypeLabel:
        {
            if (manager.label)
            {
                return manager.label;
            }
        }
            break;
        case BGAlertViewActionTypeButton:
        {
            if (manager.button)
            {
                return manager.button;
            }
        }
            break;
        case BGAlertViewActionTypeTextField:
        {
            if (manager.textField)
            {
                return manager.textField;
            }
        }
            break;
        case BGAlertViewActionTypeImageView:
        {
            if (manager.imageView)
            {
                return manager.imageView;
            }
        }
            break;
        case BGAlertViewActionTypeCustomView:
        {
            if (manager.customView)
            {
                return manager.customView;
            }
        }
            break;
        case BGAlertViewActionTypeAction:
        {
            if (manager.button)
            {
                return manager.button;
            }
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}
- (void)closeAnimation{
    if (_isAlwaysVisible) {
        return;
    }
    [self closeAnimationOperation];
}
- (void)closeAnimationOperation{
    if (self.animationCompletionHandler) {
        self.animationCompletionHandler(_contentView, _backgroundView, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
    [_innerViews removeAllObjects];
    _isAlwaysVisible = NO;
}

#pragma mark - GestureRecognizer Action
/** 触发背景 */
- (void)tapedOnAction:(UITapGestureRecognizer *)tap{
    BOOL isAboutToClose = YES;
    if (_tapAlertViewEndEidt) {
        UIView *responder = [self searchFirstResponder];
        if (responder) {
            [responder endEditing:YES];
            isAboutToClose = NO;
        }
    }
    
    if (isAboutToClose) {//没有文本视图 响应键盘
        if (_tapAlertViewClose) {
            UIView *responder = [self searchFirstResponder];
            if (!responder) {
                [self closeAnimation];
            }
        }
        
        if (self.tapAlertViewHandle) {
            self.tapAlertViewHandle();
        }
    }
}
- (void)contentViewTapedOnAction:(UITapGestureRecognizer *)tap{
    if (_tapAlertViewEndEidt) {
        UIView *responder = [self searchFirstResponder];
        if (responder)
        {
            [responder endEditing:YES];
        }
    }
}
- (void)closeAlertView{
    [self closeAnimationOperation];
}
#pragma mark - Getter&Setter
- (UIView *)searchFirstResponder{
    for (BGActionViewManager *manager in _innerViews)
    {
        if (manager.type == BGAlertViewActionTypeTextField && manager.textField)
        {
            if (manager.textField.isFirstResponder)
            {
                return manager.textField;
            }
        }
    }
    return nil;
}
- (void)setEnableContenViewGesture:(BOOL)enableContenViewGesture{
    _enableContenViewGesture = enableContenViewGesture;
    if (!enableContenViewGesture) {
        for (UIGestureRecognizer *recognizer in _contentView.gestureRecognizers) {
            recognizer.enabled = NO;
        }
    }
}
- (NSTimer *)autoHideTimer{
    if (!_autoHideTimer) {
        if (_autoHideTimeInterval <= 0)
        {
            return nil;
        }
        __weak typeof(self) weakSelf = self;
        _autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:_autoHideTimeInterval repeats:NO block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf closeAlertView];
        }];
    }
    return _autoHideTimer;
}
@end
