//
//  LWRouterRequest.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LWRouteHandle.h"
NS_ASSUME_NONNULL_BEGIN
@interface LWRouteRequest : NSObject
- (instancetype _Nullable )initWithPath:(nonnull NSString *)routePath
                              paramters:(LWParameters _Nullable )paramters;

@property(nonatomic,copy,readonly)NSString *routePath;
@property(nonatomic,strong,readonly)LWParameters paramters;
@end


@interface LWRouteRequest(CreateByURL)
- (instancetype)initWithURL:(NSURL *)URL;

@property (nonatomic,strong,nullable) NSURL *originalURL;

@end
NS_ASSUME_NONNULL_END
