//
//  RouterServiceDemo.m
//  spec_localProject
//
//  Created by Little.Daddly on 2019/8/20.
//  Copyright © 2019 Little.Daddly. All rights reserved.
//

#import "RouterServiceDemo.h"

@implementation RouterServiceDemo
LWROUTER_EXTERN_METHOD(demo) {
    NSDictionary *dic = arg;
    return nil;
}
@end
