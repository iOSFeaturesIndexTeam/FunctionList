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
#import "SubscibeProtocol.h"
#import "SubscibeCenter.h"
NSString * const CELL_ID = @"cellId";
@interface DesignModeViewController ()
@property (nonatomic,strong) NSArray *designModeArray;
@property (nonatomic,strong) UITableView *tabV;
@end

@implementation DesignModeViewController
- (void)dealloc{
    [SubscibeCenter removeUser:self withNumber:@"订阅号-美食"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"24 种设计模式";
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
    } else if(indexPath.row < 12) {
        cell.backgroundColor = [UIColor greenColor];
    } else if(indexPath.row == self.designModeArray.count -1) {
        cell.backgroundColor = [UIColor yellowColor];
    } else if (indexPath.row == self.designModeArray.count -2){
        cell.backgroundColor = [UIColor blueColor];
    } else {
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

#pragma mark - SubscibeProtocol
- (void)sendMessage:(NSString *)message withSubscibeNum:(NSString *)subscibeNum {
    NSLog(@"message is : %@ , number is : %@",message,subscibeNum);
}

#pragma mark - getter
- (NSArray *)designModeArray {
    if (!_designModeArray) {
        _designModeArray = @[@"工厂方法模式",@"抽象工厂模式",@"单例模式 太常用不介绍了",@"构建者模式",@"原型模式",
                             
                             @"适配器模式",@"装饰器模式 就是objc中的分类不介绍了",@"代理模式 常用不讲",@"外观模式 暴露一个接口输出目标，过程隐藏",@"桥接模式",@"组合模式",@"享元模式",
                             
                             @"策略模式",@"模板模式 一个基类，多个子类重写基类方法",@"观察者模式",@"中介者模式",@"迭代器模式 迭代器模式 单向链表遍历不讲",@"责任链模式",
                             @"命令模式",@"备忘录模式",@"状态模式 没看出和策略模式的不同不讲",@"访问者模式",@"解释器模式",
                             
                             @"路由器设计",
                             @"RAC+MVVM"
                             ];
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
