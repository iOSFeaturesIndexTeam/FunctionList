//
//  RemoteControlLayer.h
//  spec_localProject
//
//  Created by Little.Daddly on 2020/2/8.
//  Copyright © 2020 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger,RemoteControlType){
    RemoteControlTypeUp = 1,
    RemoteControlTypeLeft ,
    RemoteControlTypeRight ,
    RemoteControlTypeDown ,
    RemoteControlTypeOk
};

@interface RemoteControlLayer : UIView

@end

NS_ASSUME_NONNULL_END
