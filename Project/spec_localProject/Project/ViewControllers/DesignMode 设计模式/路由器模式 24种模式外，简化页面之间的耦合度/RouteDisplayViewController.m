//
//  RouteDisplayViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/20.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "RouteDisplayViewController.h"

@interface RouteDisplayViewController ()

@end

@implementation RouteDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
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
    return @[_JOSN_A,_JOSN_Present];
}

- (NSDictionary *)btnDic{
    return @{
             _JOSN_A:@"我是A push的",
             _JOSN_Present:@"我在present呢",
             };
}
@end
