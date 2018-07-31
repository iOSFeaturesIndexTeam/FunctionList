//
//  ViewController.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/6/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DemoIndexModel;
@interface ViewController : UIViewController
/** 索引数据 */
@property (nonatomic,strong) NSArray <DemoIndexModel *>*data;
@end

@interface DemoIndexModel : NSObject
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 跳转vc */
@property (nonatomic,copy) NSString *vcName;

@end
