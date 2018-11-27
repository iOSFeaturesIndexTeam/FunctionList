//
//  UITableView+Extend.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/15.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "UITableView+Extend.h"

@implementation UITableView (Extend)
+ (instancetype)tabvWithTarget:(id)target {
    return [self tabvWithTarget:target type:UITableViewStylePlain];
}
+ (instancetype)tabvWithTarget:(id)target type:(UITableViewStyle)type{
    __kindof UITableView *tabV = [[self alloc] initWithFrame:CGRectZero style:type];
    tabV.delegate = target;
    tabV.dataSource = target;
    tabV.tableFooterView = [[UIView alloc] init];
    tabV.tableHeaderView = [[UIView alloc] init];
    tabV.showsVerticalScrollIndicator = NO;
    tabV.showsHorizontalScrollIndicator = NO;
    tabV.sectionHeaderHeight = 0.1;
    tabV.sectionFooterHeight = 0.1;
    tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tabV;
}

+ (instancetype)tabvGroupWithTarget:(id)target {
   return [self tabvWithTarget:target type:UITableViewStyleGrouped];
}
@end
