//
//  PushAViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/20.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "PushAViewController.h"

@interface PushAViewController ()
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,copy)LWRouteHandler routeOptionHandle;
@end

@implementation PushAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIButton lw_createView:^(__kindof UIButton *btn) {
        [UIButton defaultType:btn];
        NSString *key = _JOSN_B;
        [btn setTitle:key forState:UIControlStateNormal];
        
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            [LWRoute.manager handlerRequest:[LWRouteRequest requestWithPath:key andParam:@{@"B":@"走你 我是B"}] optionHandle:^(id result, NSError *error) {
//                KCLog(@"%@",result);
//            }];
            
            /** 测试路由服务模块 */
            [LWRoute.manager handlerRequest:[LWRouteRequest requestServicePath:Router_Service_Demo andParam:@{@"B":@"走你 我是B"}] optionHandle:^(id result, NSError *error) {
                
            }];
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_routeOptionHandle) {
        self.routeOptionHandle(@"A 离开了,并说了一声Hello", nil);
    }
}

+ (NSString *)routePath {return _JOSN_A;}
+ (void)handleRequest:(LWParameters)parameters
    topViewController:(UIViewController *)topViewController
         optionHandle:(LWRouteHandler)optionHandle{
    KCLog(@"A 获取请求 %@",parameters);
    PushAViewController *vc = [[PushAViewController alloc] init];
    vc.data = parameters;
    vc.routeOptionHandle = optionHandle;
    [topViewController.navigationController pushViewController:vc animated:YES];
}


@end
