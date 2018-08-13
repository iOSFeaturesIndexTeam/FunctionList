//
//  LayerDrawInRectViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/13.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "LayerDrawInRectViewController.h"
#import "CustomLayer.h"
@class BGCustomLayerModel;
@interface LayerDrawInRectViewController ()
@property (nonatomic,strong) CustomLayer *customlayer;
@end

@implementation LayerDrawInRectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureScreen];
}

- (void)configureScreen {
    [UIButton lw_createView:^(__kindof UIButton *btn) {
        [btn setBackgroundColor:[UIColor orangeColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"绘制View" forState:UIControlStateNormal];
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            BGCustomLayerModel *model = [BGCustomLayerModel new];
            model.name = @"自己画的视图哦！！";
            _customlayer = [[CustomLayer alloc] initLayerType:BGCustomLayerTypeTag withInfo:model];
            _customlayer.frame = CGRectMake(0, 64, [_customlayer approximatelySize].width, [_customlayer approximatelySize].height);
            [self.view addSubview:_customlayer];
        }];
        
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
    }];
}
@end
