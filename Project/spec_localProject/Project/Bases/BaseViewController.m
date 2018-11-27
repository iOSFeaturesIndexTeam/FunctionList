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
         [viewController layoutCustomNavigationBar];
     }];
    
    return viewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:[self isHiddenNaviBar]?YES:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:[self isHiddenNaviBar]?YES:NO animated:NO];
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
- (void)layoutCustomNavigationBar {
    //防止pop的时候导航栏闪动
    if ([self isHiddenNaviBar]) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}
- (BOOL)isHiddenNaviBar{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
+ (void)handleRequest:(LWParameters)parameters topViewController:(UIViewController *)topViewController optionHandle:(LWRouteHandler)optionHandle {}

+ (NSString *)routePath { return @"";}
@end
