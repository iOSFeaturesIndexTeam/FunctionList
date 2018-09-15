//
//  DesignModeViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/15.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "DesignModeViewController.h"
#import "UITableView+Extend.h"
#import "DesignModeViewController+Extend.h"

NSString * const CELL_ID = @"cellId";
@interface DesignModeViewController ()<kBaseTabViewDelegate>
@property (nonatomic,strong) NSArray *designModeArray;
@property (nonatomic,strong) UITableView *tabV;
@end

@implementation DesignModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"24 种设计模式";
    [self.view addSubview:self.tabV];
    [_tabV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.designModeArray objectAtIndex:indexPath.row];
    if (indexPath.row < 5) {
        cell.backgroundColor = [UIColor redColor];
    }else if(indexPath.row < 12){
        cell.backgroundColor = [UIColor greenColor];
    }else{
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.designModeArray.count;;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *type = [self.designModeArray objectAtIndex:indexPath.row];
    NSLog(@"\n\n=================设计模式：%@=================\n\n",type);
    
    [DesignModeViewController runDesignModeType:indexPath.row];
}

#pragma mark - getter
- (NSArray *)designModeArray {
    if (!_designModeArray) {
        _designModeArray = @[@"工厂方法模式",@"抽象工厂模式",@"单例模式 太常用不介绍了",@"构建者模式",@"原型模式",
                             
                             @"适配器模式",@"装饰器模式 就是objc中的分类不介绍了",@"代理模式",@"外观模式",@"桥接模式",@"组合模式",
                             @"享元模式",
                             
                             @"策略模式",@"模板模式",@"观察者模式",@"中介者模式",@"迭代器模式",@"责任链模式",
                             @"命令模式",@"备忘录模式",@"状态模式",@"访问者模式",@"解释器模式"];
    }
    return _designModeArray;
}

- (UITableView *)tabV{
    if (!_tabV) {
        _tabV = [UITableView tabvWithTarget:self];
        _tabV.rowHeight = 60.f;
        [_tabV registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_ID];
    }
    return _tabV;
}
@end
