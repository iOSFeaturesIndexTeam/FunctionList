//
//  MobilephoneFactory.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "AbstractFactory.h"

@interface MobilephoneFactory : AbstractFactory
/** 实体卡，移动、联通、电信 卡 */
@property (nonatomic,copy) NSString *physicalCard;

@end
