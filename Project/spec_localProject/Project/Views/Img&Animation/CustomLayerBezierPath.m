//
//  customLayerBezierPath.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/14.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "CustomLayerBezierPath.h"
/** 120/34 */
@implementation CustomLayerBezierPath

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(107.93, 1.11)];
    [bezier2Path addLineToPoint: CGPointMake(108.58, 1.27)];
    [bezier2Path addCurveToPoint: CGPointMake(119, 16.15) controlPoint1: CGPointMake(114.84, 3.55) controlPoint2: CGPointMake(119, 9.49)];
    [bezier2Path addCurveToPoint: CGPointMake(119, 17) controlPoint1: CGPointMake(119, 17) controlPoint2: CGPointMake(119, 17)];
    [bezier2Path addLineToPoint: CGPointMake(119, 17.85)];
    [bezier2Path addCurveToPoint: CGPointMake(108.58, 32.73) controlPoint1: CGPointMake(119, 24.51) controlPoint2: CGPointMake(114.84, 30.45)];
    [bezier2Path addCurveToPoint: CGPointMake(93.33, 34) controlPoint1: CGPointMake(104.56, 34) controlPoint2: CGPointMake(100.81, 34)];
    [bezier2Path addLineToPoint: CGPointMake(68.93, 34)];
    [bezier2Path addCurveToPoint: CGPointMake(57.07, 32.89) controlPoint1: CGPointMake(64.19, 34) controlPoint2: CGPointMake(60.44, 34)];
    [bezier2Path addLineToPoint: CGPointMake(56.42, 32.73)];
    [bezier2Path addCurveToPoint: CGPointMake(46.94, 23.24) controlPoint1: CGPointMake(51.92, 31.09) controlPoint2: CGPointMake(48.51, 27.56)];
    [bezier2Path addCurveToPoint: CGPointMake(27.03, 25.49) controlPoint1: CGPointMake(43.51, 22.29) controlPoint2: CGPointMake(37.49, 22.25)];
    [bezier2Path addCurveToPoint: CGPointMake(15.5, 31) controlPoint1: CGPointMake(24.38, 28.84) controlPoint2: CGPointMake(20.2, 31)];
    [bezier2Path addCurveToPoint: CGPointMake(1, 17) controlPoint1: CGPointMake(7.49, 31) controlPoint2: CGPointMake(1, 24.73)];
    [bezier2Path addCurveToPoint: CGPointMake(10.24, 3.95) controlPoint1: CGPointMake(1, 11.06) controlPoint2: CGPointMake(4.83, 5.98)];
    [bezier2Path addCurveToPoint: CGPointMake(15.5, 3) controlPoint1: CGPointMake(11.87, 3.34) controlPoint2: CGPointMake(13.64, 3)];
    [bezier2Path addCurveToPoint: CGPointMake(26.88, 8.33) controlPoint1: CGPointMake(20.11, 3) controlPoint2: CGPointMake(24.23, 5.08)];
    [bezier2Path addCurveToPoint: CGPointMake(47.19, 10.13) controlPoint1: CGPointMake(31.66, 9.93) controlPoint2: CGPointMake(40.92, 12.42)];
    [bezier2Path addCurveToPoint: CGPointMake(56.42, 1.27) controlPoint1: CGPointMake(48.85, 6.09) controlPoint2: CGPointMake(52.14, 2.83)];
    [bezier2Path addCurveToPoint: CGPointMake(68.31, 0.01) controlPoint1: CGPointMake(59.79, 0.21) controlPoint2: CGPointMake(62.97, 0.03)];
    [bezier2Path addCurveToPoint: CGPointMake(68.93, 0) controlPoint1: CGPointMake(68.51, 0) controlPoint2: CGPointMake(68.72, 0)];
    [bezier2Path addCurveToPoint: CGPointMake(71.67, 0) controlPoint1: CGPointMake(69.79, -0) controlPoint2: CGPointMake(70.7, 0)];
    [bezier2Path addLineToPoint: CGPointMake(96.07, 0)];
    [bezier2Path addCurveToPoint: CGPointMake(107.93, 1.11) controlPoint1: CGPointMake(100.81, 0) controlPoint2: CGPointMake(104.56, 0)];
    [bezier2Path closePath];
    [UIColor.grayColor setFill];
    [bezier2Path fill];
    [UIColor.grayColor setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
}


@end
