//
//  RouteDisplayViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/20.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "RouteDisplayViewController.h"
#import "WebBrigdeObjcViewController.h"
@interface RouteDisplayViewController ()

@end

@implementation RouteDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    LWRoute.manager.unHandlerCallback = ^(LWRouteRequest *request, UIViewController *topViewController) {
        WebBrigdeObjcViewController *webVC = [WebBrigdeObjcViewController new];
        if ([request.paramters hasPrefix:@"http"]) {
            webVC.remoteURL = request.paramters;
            [topViewController presentViewController:webVC animated:YES completion:nil];
        } else {
            /** 其余处理 */
        }
    };
}

- (void)initSubviews{
    for (int i = 0; i < self.btnData.count; i++) {
        [UIButton lw_createView:^(__kindof UIButton *btn) {
            [UIButton defaultType:btn];
            NSString *key = self.btnData[i];
            [btn setTitle:key forState:UIControlStateNormal];
            
            [self.view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.centerX.equalTo(self.view).offset((130 * i) - 130);
                make.size.mas_equalTo(CGSizeMake(100, 40));
            }];
            
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                [LWRoute.manager handlerRequest:[LWRouteRequest requestWithPath:key andParam:self.btnDic[key]] optionHandle:^(id result, NSError *error) {
                    KCLog(@"%@",result);
                }];
            }];
        }];
    }
    
}

- (NSArray <NSString *>*)btnData{
    return @[_JOSN_A,_JOSN_Present,_JOSN_RemotURL];
}

- (NSDictionary *)btnDic{
    return @{
             _JOSN_A:@"我是A push的",
             _JOSN_Present:@"我在present呢",
             _JOSN_RemotURL:[NSURL URLWithString:@"http://theo2life.com"]
             };
}
@end
