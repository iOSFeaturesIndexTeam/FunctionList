//
//  ResponderViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/7/29.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "ResponderViewController.h"
#import <UIView+LW_BlockCreate.h>
#import <Masonry.h>
@interface ResponderViewController ()
@property (nonatomic,strong) UIButton *respondBtn;
@end

@implementation ResponderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _respondBtn = [UIButton lw_createView:^(UIButton *btn) {
        [self.view addSubview:btn];
        btn.tag = 1001;
        [btn setTitle:@"点击" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(200, 100));
        }];
    }];
}
- (void)click:(UIButton *)sender{
    NSLog(@"按钮事件触发");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"视图控制器事件触发");
}

@end
