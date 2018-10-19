//
//  UITableView+Extend.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/15.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "UITableView+Extend.h"

@implementation UITableView (Extend)
+ (UITableView *)tabvWithTarget:(id)target {
    return [UITableView tabvWithTarget:target type:UITableViewStylePlain];
}
+ (UITableView *)tabvWithTarget:(id)target type:(UITableViewStyle)type{
    UITableView *tabV = [[UITableView alloc] initWithFrame:CGRectZero style:type];
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

+ (UITableView *)tabvGroupWithTarget:(id)target {
   return [UITableView tabvWithTarget:target type:UITableViewStyleGrouped];
}
@end
