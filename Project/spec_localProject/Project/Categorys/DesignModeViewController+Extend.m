
//
//  DesignModeVC+Extend.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "DesignModeViewController+Extend.h"
#import "AppDelegate.h"
#import "Factory.h"
#import "MobilephoneFactory.h"
#import "RefrigeratorFactory.h"
#import "ClassModel.h"
#import "ViewAdapter.h"
#import "BGAlertView+BGAdd.h"
#import "FlowerFactory.h"
#import "CompositePatternViewController.h"
@implementation DesignModeViewController (Extend)
+ (void)runDesignModeType:(DesignMode)mode{
    switch (mode) {
        case DesignModeFactory:
            [DesignModeViewController Factory];
            break;
        case DesignModeAbstractFactory:
            [DesignModeViewController AbstractFactory];
            break;
        case DesignModePrototype:
            [DesignModeViewController Prototype];
            break;
        case DesignModeAdapter:
            [DesignModeViewController Adapter:[UIApplication sharedApplication].keyWindow];
            break;
        case DesignModeFlyweight:
            [DesignModeViewController Flyweight];
            break;
        case DesignModeComposite:
            [DesignModeViewController Composite];
            break;
        default:
            break;
    }
}

/** #工厂模式
 场景：一个工厂类 ，通过一个接口生产出 一类的产品
 例如：笔杆加工厂，根据客户的需求 加工出 铅笔、圆珠笔
 */
+ (void)Factory{
    Pen *pen_1 = [Factory productPenWithType:PenTypePencil];
    [pen_1 isHeavy];
    [(Pencil *)pen_1 Character];
    
    Pen *pen_2 = [Factory productPenWithType:PenTypeBallpointPen];
    [pen_2 isExpensive];
}

/** #抽象工厂模式
 有一个超级工厂，工厂往下有各个子工厂，细分自己的任务
 */
+ (void)AbstractFactory{
    [[MobilephoneFactory product] productInfo];
    [[RefrigeratorFactory product] productInfo];
}
/** #原型模式
    场景：数据进行 拷贝，重复对象
 */
+ (void)Prototype{
    Student *stu1 = [Student new];
    stu1.name = @"stu_1";
    stu1.studentId = @"001";
    
    Student *stu2 = [stu1 copy];
    stu2.studentId = @"002";
    
    KCLog(@"stu1--%@ ,stu2 -- %@",stu1,stu2);
    
    ClassModel *m = [ClassModel new];
    m.className = @"五班";
    m.students = @[stu1,stu2];
    ClassModel *m_copy = m.copy;
    m_copy.students[0].studentId = @"003";
    KCLog(@"\n class -- %@ ,classCopy -- %@",m,m_copy);
}
/** #适配器
    场景：同数据源经过不同的适配器中的筛子，产出不同的适配效果
 */
+ (void)Adapter:(UIView *)superV{
    extModel *m = [extModel new];
    m.distance = @"1000 m";
    m.shopName = @"littleDaddly";
    [ViewAdapter shareManager];
    
    [BGAlertView normalAlertWithTitle:@"适配器模式" subBtnTitle:@[@"适配大图",@"适配小图"] actionTapedHandler:^(NSInteger index) {
        if (index == 1000) {
            [ViewAdapter BigViewAdapterWithModel:m superView:superV];
        } else {
            [ViewAdapter SmallViewAdapterWithModel:m superView:superV];
        }
    }];
}
/** #享元模式
    场景：UITableViewCell 复用池
 */
+ (void)Flyweight{
    for (int i = 0; i < 5; i++) {
        [[FlowerFactory new] multiplexFlowerWithType:arc4random_uniform(3)];
    }
}
/** #组合模式
    树状结构
 */
+ (void)Composite{
   UINavigationController *navc = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    for (UIViewController *vc in navc.viewControllers) {
        if ([[vc className] isEqualToString:[[self class] className]]) {
            [vc.navigationController pushViewController:[CompositePatternViewController new] animated:YES];
        }
    }
}
@end
