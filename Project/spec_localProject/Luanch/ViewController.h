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
/** 描述 */
@property (nonatomic,copy) NSString *des;
/** 子节点 */
@property (nonatomic,strong) NSMutableArray <DemoIndexModel *>*subList;

/** 初始化数据 */
+ (NSArray <DemoIndexModel *>*)initListDataWithJSON:(NSDictionary *)JSONDic;
@end
