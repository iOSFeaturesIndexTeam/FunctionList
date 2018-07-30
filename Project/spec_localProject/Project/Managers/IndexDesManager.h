//
//  IndexDesManager.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/7/29.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ViewController.h"

/**
 索引描述管理者
 */
@interface IndexDesManager : NSObject
+ (NSString *)filerWithIndexModel:(DemoIndexModel *)model;
@end
