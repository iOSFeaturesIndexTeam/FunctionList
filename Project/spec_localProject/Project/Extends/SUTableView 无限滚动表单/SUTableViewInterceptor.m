//
//  SUTableViewInterceptor.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/16.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "SUTableViewInterceptor.h"

@implementation SUTableViewInterceptor

#pragma mark - forward & response override
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]){
         return self.middleMan;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}
@end
