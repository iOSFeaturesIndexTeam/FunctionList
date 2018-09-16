//
//  DesignModeVC+Extend.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "DesignModeViewController.h"
/**  @"工厂方法模式":@"FactoryPatternViewController",
 @"抽象工厂模式":@"AbstractFactoryPatternViewController",
 @"单例模式":@"SingletonPatternViewController",
 @"构建者模式":@"BuilderViewController",
 @"原型模式":@"PrototypePatternViewController",
 
 
 
 @"外观模式":@"FacadePatternViewController",
 @"桥接模式":@"BridgePatternViewController",
 @"组合模式":@"CompositePatternViewController",
 @"享元模式":@"FlyweightPatternViewController",
 
 @"策略模式":@"StrategyPatternViewController",
 @"模板模式":@"TemplatePatternViewController",
 @"观察者模式":@"ObserverPatternViewController",
 @"中介者模式":@"MediatorPatternViewController",
 @"迭代器模式":@"IteratorPatternViewController",
 @"责任链模式":@"ChainOfResponsibilityPatternViewController",
 @"命令模式":@"CommandPatternViewController",
 @"备忘录模式":@"MementoPatternViewController",
 @"状态模式":@"StatePatternViewController",
 @"访问者模式":@"VisitorPatternViewController",
 @"解释器模式":@"InterpreterPatternViewController"
 */
typedef NS_ENUM(NSUInteger,DesignMode) {
    DesignModeFactory,
    DesignModeAbstractFactory,
    DesignModeSingleton,
    DesignModeBuilder,
    DesignModePrototype,//原型
    
    DesignModeAdapter,
    DesignModeDecorator,
    DesignModeDelegate,
    DesignModeFacade,
    DesignModeBridge,
    DesignModeComposite,
    DesignModeFlyweight,
    
    DesignModeStrategy,
    DesignModeTemplate,
    DesignModeObserver,
    DesignModeMediator,
    DesignModeIterator,
    DesignModeChainOfResponsibility,
    DesignModeCommand,
    DesignModeMemento,
    DesignModeState,
    DesignModeVisitor,
    DesignModeInterpreter
};
@interface DesignModeViewController (Extend)
+ (void)runDesignModeType:(DesignMode)mode;
@end
