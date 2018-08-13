//
//  CustomLayer.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/13.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 我们一般绘制自定义的 视图控件，计算frame
 就是算嘛
 */
typedef NS_ENUM(NSUInteger,BGCustomLayerType) {
    BGCustomLayerTypeTag,//标签
    BGCustomLayerTypeSlider,//滑竿
    BGCustomLayerTypeProgressBar//进度条
};
@class BGCustomLayerModel;

@interface CustomLayer : UIView
- (instancetype)initLayerType:(BGCustomLayerType)type withInfo:(BGCustomLayerModel *)info;
@property (nonatomic,assign,readonly) BGCustomLayerType type;
@property (nonatomic,strong) BGCustomLayerModel *info;
/** 额外操作 */
@property (nonatomic,copy) void (^ option)(void);
- (CGSize)approximatelySize;
@end

/**
 绘制模型信息
 */
@interface BGCustomLayerModel : NSObject
@property (nonatomic,copy) NSString *name;
/** 分类图片朝向(true为右) */
@property (nonatomic) BOOL direction;
@end
