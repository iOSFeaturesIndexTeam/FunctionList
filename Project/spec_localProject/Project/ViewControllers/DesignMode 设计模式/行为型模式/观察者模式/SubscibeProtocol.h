//
//  SubscibeProtocol.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubscibeProtocol <NSObject>

@required

- (void)sendMessage:(NSString *)message withSubscibeNum:(NSString *)subscibeNum;

@end
