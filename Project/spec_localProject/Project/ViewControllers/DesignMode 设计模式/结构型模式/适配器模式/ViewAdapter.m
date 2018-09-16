//
//  ViewAdapter.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "ViewAdapter.h"
#import "BigView.h"
#import "SmallView.h"
static ViewAdapter *owner = nil;
@interface ViewAdapter ()
@property (nonatomic,strong) BigView *bigV;
@property (nonatomic,strong) SmallView *smallV;
@end

@implementation ViewAdapter
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        owner = [ViewAdapter new];
    });
    return owner;
}
+ (instancetype)BigViewAdapterWithModel:(extModel *)m superView:(UIView *)superV{
    
    BigView *big = [BigView new];
    owner.bigV = big;
    big.backgroundColor = [UIColor redColor];
    [superV addSubview:big];
    [big mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(200 , 200));
    }];
    [owner removeViews];
    return owner;
}
+ (instancetype)SmallViewAdapterWithModel:(extModel *)m superView:(UIView *)superV{
    
    SmallView *small = [SmallView new];
    owner.smallV = small;
    small.backgroundColor = [UIColor blueColor];
    [superV addSubview:small];
    [small mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50 , 50));
    }];
    [owner removeViews];
    return owner;
}
+ (instancetype)SuperBigViewAdapterWithModel:(extModel *)m superView:(UIView *)superV{
    return nil;
}

- (void)removeViews{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_bigV removeFromSuperview];
        [_smallV removeFromSuperview];
    });
}
@end
