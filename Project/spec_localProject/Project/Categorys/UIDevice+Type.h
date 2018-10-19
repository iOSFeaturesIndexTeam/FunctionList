//
//  UIDevice+Type.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/17.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,LWDeviceSeries) {
    i5 = 0,
    i6Series,
    i6PSeries,
    iXSeries,// iX  iXs
    iXMac,
    iXr,
    unknownSeries,
};

@interface UIDevice (Type)
+ (LWDeviceSeries)deviecType;
@end
