//
//  UIDevice+Type.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/17.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "UIDevice+Type.h"

@implementation UIDevice (Type)
+ (LWDeviceSeries)deviecType{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            case 1136: KCLog(@"iPhone 5 or 5S or 5C"); return i5;
            case 1334: KCLog(@"iPhone 6/6S/7/8"); return i6Series;
            case 1920: KCLog(@"iPhone 6+/6S+/7+/8+"); return i6PSeries;
            case 2436: KCLog(@"iPhone X, Xs"); return iXSeries;
            case 2688: KCLog(@"iPhone Xs Max"); return iXMac;
            case 1792: KCLog(@"iPhone Xr"); return iXr;
            default: KCLog(@"unknown");
        }
    }
    return unknownSeries;
}
@end
