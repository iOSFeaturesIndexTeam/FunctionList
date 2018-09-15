
//
//  DesignModeVC+Extend.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "DesignModeViewController+Extend.h"
#import "Factory.h"
#import "MobilephoneFactory.h"
#import "RefrigeratorFactory.h"
@implementation DesignModeViewController (Extend)
+ (void)runDesignModeType:(DesignMode)mode{
    switch (mode) {
        case DesignModeFactory:
            [DesignModeViewController Factory];
            break;
        case DesignModeAbstractFactory:
            [DesignModeViewController AbstractFactory];
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
@end
