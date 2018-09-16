//
//  DirectionRemote.m
//  DesignModeDemo
//
//  Created by koala on 2018/4/13.
//  Copyright © 2018年 koala. All rights reserved.
//

#import "DirectionRemote.h"

@implementation DirectionRemote

- (void)up {
    [self setCommand:@"up"];
}

- (void)down {
    [self setCommand:@"down"];
}

- (void)left {
    [self setCommand:@"left"];
}

- (void)right {
    [self setCommand:@"right"];
}

@end
