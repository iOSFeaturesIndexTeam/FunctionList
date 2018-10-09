//
//  ComponentViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/9.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "ComponentViewController.h"
#import "LWPageControl.h"
@interface ComponentViewController ()

@end

@implementation ComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LWPageControl lw_createView:^(__kindof LWPageControl *pageControl) {
        pageControl.sizeForPageIndicator = CGSizeMake(10, 10);
        pageControl.itemsPadding = 8;
        pageControl.currentPage = 2;
        pageControl.itemsPage = 5;
        
        [self.view addSubview:pageControl];
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
    }];
}

@end
