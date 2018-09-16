
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
#import "HaierAirConditioner.h"
#import "DirectionRemote.h"
#import "TemperatureRemote.h"
#import "GeliAirConditioner.h"
#import "Context.h"
#import "OperationAdd.h"
#import "OperationMultiply.h"
#import "OperationSubStract.h"
#import "Receiver.h"
#import "DarkerCommand.h"
#import "LighterCommand.h"
#import "Invoker.h"
#import "SubscibeCenter.h"
#import "ConcreteColleague.h"
#import "ConcreteMediator.h"
#import "GroupLeaderHandler.h"
#import "ManagerHandler.h"
#import "ChairmanHandler.h"
static Receiver * receiver = nil;
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
        case DesignModeBridge:
            [DesignModeViewController Bridge];
            break;
        case DesignModeStrategy:
            [DesignModeViewController Strategy];
            break;
        case DesignModeCommand:
            [DesignModeViewController Command];
            break;
        case DesignModeObserver:
            [DesignModeViewController Observer];
            break;
        case DesignModeMediator:
            [DesignModeViewController Mediator];
            break;
        case DesignModeChainOfResponsibility:
            [DesignModeViewController ChainOfResponsibility];
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
    [AppDelegate currentVC:[self class] Exec:^(UIViewController *vc) {
        [vc.navigationController pushViewController:[CompositePatternViewController new] animated:YES];
    }];
}
/** #桥接模式
    和适配器很像，就多有个桥接文件
 */
+ (void)Bridge{
    //海尔空调
    HaierAirConditioner *haierAirConditioner =  [[HaierAirConditioner alloc] init];
    //控制风向
    DirectionRemote *directionRemote = [[DirectionRemote alloc] init];
    //让海尔空调往上吹风
    directionRemote.airConditioner = haierAirConditioner;
    [directionRemote up];
    
    //控制温度
    TemperatureRemote *temperatureRemote = [[TemperatureRemote alloc] init];
    //让海尔空调更冷
    temperatureRemote.airConditioner = haierAirConditioner;
    [temperatureRemote colder];
    
    //让格力空调往下吹热风
    GeliAirConditioner *geliAirConditioner =  [[GeliAirConditioner alloc] init];
    directionRemote.airConditioner = geliAirConditioner;
    [directionRemote down];
    temperatureRemote.airConditioner = geliAirConditioner;
    [temperatureRemote warmer];
}

+ (void)Strategy{
    Context * context = [[Context alloc]init];
    context.strategy = [OperationAdd new];
    [context calulate];
    context.strategy = [OperationMultiply new];
    [context calulate];
    context.strategy = [OperationSubStract new];
    [context calulate];
}

+ (void)Command{
    receiver = [Receiver new];
    __block UIView *mask_v = nil;
    [AppDelegate currentVC:[self class] Exec:^(UIViewController *vc) {
        mask_v = [[UIView alloc] initWithFrame:vc.view.bounds];
        mask_v.backgroundColor = [UIColor blackColor];
        [vc.view addSubview:mask_v];
        [receiver setReceiverView:mask_v];
    }];
    
    [BGAlertView alertTitle:@"命令模式" actionTitles:@[@"加黑",@"变量",@"撤销"] actionTapedHandler:^(NSInteger index) {
        if (index == 1000) {
            DarkerCommand *command = [[DarkerCommand alloc] initWithReceiver:receiver paramter:0.1];
            [[Invoker sharedInstance] addAndExcute:command];
        } else if (index == 1001){
            LighterCommand *command = [[LighterCommand alloc] initWithReceiver:receiver paramter:0.1];
            [[Invoker sharedInstance] addAndExcute:command];
        } else {
            [[Invoker sharedInstance] goBack];
        }
    } closeOption:^{
        [mask_v removeFromSuperview];
    }];
}

+ (void)Observer{
    
    [SubscibeCenter addUser:self withNumber:@"订阅号-美食"];
    //收不到这个消息
    [SubscibeCenter sendMessage:@"有新书啦" withNumber:@"订阅号-书记"];
    
    //可以收到这条消息
    [SubscibeCenter sendMessage:@"簋街牛蛙贼好吃" withNumber:@"订阅号-美食"];
}
+ (void)Mediator{
    //中介报价
    ConcreteMediator *mediator = [ConcreteMediator new];
    
    //卖房者A
    ConcreteColleague *colleagueA = [ConcreteColleague new];
    mediator.colleagueA = colleagueA;
    colleagueA.delegate = mediator;
    [colleagueA chooseRoomSizeChanged:80];
    
    
    //卖房者B
    ConcreteColleague *colleagueB = [ConcreteColleague new];
    mediator.colleagueB = colleagueB;
    colleagueB.delegate = mediator;
    [colleagueB chooseRoomSizeChanged:120];
    
    KCLog(@"所有卖房者去公摊后的实际面积：%@", [mediator values]);
}

+ (void) ChainOfResponsibility{
    Handler *handler1 = [[GroupLeaderHandler alloc] init];
    Handler *handler2 = [[ManagerHandler alloc] init];
    Handler *handler3 = [[ChairmanHandler alloc] init];
    
    handler1.successor = handler2;
    handler2.successor = handler3;
    
    Order *order = [[Order alloc] init];
    order.orderMoney = 500;
    [handler1 handlerOrder:order];
    KCLog(@"###############################\n");
    
    order.orderMoney = 3000;
    [handler1 handlerOrder:order];
    KCLog(@"###############################\n");
    
    
    order.orderMoney = 20000;
    [handler1 handlerOrder:order];
    KCLog(@"###############################\n");
    
    order.orderMoney = 500000;
    [handler1 handlerOrder:order];
}

@end
