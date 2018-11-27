//
//  UITableView+Extend.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/15.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extend)
/** plain type */
+ (instancetype)tabvWithTarget:(id)target;
/** group type */
+ (instancetype)tabvGroupWithTarget:(id)target;
@end
