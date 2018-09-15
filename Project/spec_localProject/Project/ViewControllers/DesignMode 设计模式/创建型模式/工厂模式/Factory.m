//
//  Factory.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "Factory.h"

@implementation Factory

+ (Pen *)productPenWithType:(PenType)type{
    Pen *pen = nil;
    switch (type) {
        case PenTypePencil: { pen = [Pencil new]; }
            break;
        case PenTypeBallpointPen: { pen = [BallpointPen new];}
            break;
        default:
            break;
    }
    return pen;
}
@end
