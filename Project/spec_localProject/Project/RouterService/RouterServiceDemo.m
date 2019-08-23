//
//  RouterServiceDemo.m
//  spec_localProject
//
//  Created by Little.Daddly on 2019/8/20.
//  Copyright © 2019 Little.Daddly. All rights reserved.
//

#import "RouterServiceDemo.h"

@implementation RouterServiceDemo
LWROUTER_EXTERN_METHOD(demo, arg, optionHandle) {
    NSDictionary *dic = arg;
    _lwGetTopVC();
    return nil;
}
@end
