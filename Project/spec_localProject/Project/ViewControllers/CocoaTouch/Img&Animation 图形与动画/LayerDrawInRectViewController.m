//
//  LayerDrawInRectViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/13.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "LayerDrawInRectViewController.h"
#import "CustomLayer.h"
#import "CustomLayerBezierPath.h"
#import "RemoteControlLayer.h"
static NSString * kLayerDes = @"";
@class BGCustomLayerModel;
@interface LayerDrawInRectViewController ()
@property (nonatomic,strong) CustomLayer *customlayer;
@property (nonatomic,strong) RemoteControlLayer *remoteControlLayer;
@end

@implementation LayerDrawInRectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configureScreen];
//    {   //BezierPath 绘制图形
//        CustomLayerBezierPath *path = [[CustomLayerBezierPath alloc] initWithFrame:CGRectMake(0, 100, 120, 34)];
//        [self.view addSubview:path];
//    }
    //CALayer 闭环绘制想要的图案，且设置点击特效
    [self demo3];
    
}

- (void)demo3{
    self.remoteControlLayer = [RemoteControlLayer new];
    [self.view addSubview:_remoteControlLayer];
    _remoteControlLayer.center = CGPointMake(200, 200);
}

- (void)configureScreen {
    [UIButton lw_createView:^(__kindof UIButton *btn) {
        [btn setBackgroundColor:[UIColor orangeColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"绘制View" forState:UIControlStateNormal];
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            BGCustomLayerModel *model = [BGCustomLayerModel new];
            kLayerDes = [kLayerDes stringByAppendingString:@"画-"];
            model.name = kLayerDes;
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
