//
//  BaseViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/7/29.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController initSubViews];
         [viewController dataConfigure];
         [viewController viewWillRequest];
         [viewController viewWillConfigureNotifications];
     }];
    
    return viewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _indexTitle;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearanceWhenContainedInInstancesOfClasses:@[self.class]].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)initSubViews{}
- (void)dataConfigure{}
- (void)viewWillRequest{}
- (void)viewWillConfigureNotifications{}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
