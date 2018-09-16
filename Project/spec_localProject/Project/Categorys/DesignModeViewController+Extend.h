//
//  DesignModeVC+Extend.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "DesignModeViewController.h"
typedef NS_ENUM(NSUInteger,DesignMode) {
    DesignModeFactory,
    DesignModeAbstractFactory,
    DesignModeSingleton,
    DesignModeBuilder,
    DesignModePrototype,
    
};
@interface DesignModeViewController (Extend)
+ (void)runDesignModeType:(DesignMode)mode;
@end
