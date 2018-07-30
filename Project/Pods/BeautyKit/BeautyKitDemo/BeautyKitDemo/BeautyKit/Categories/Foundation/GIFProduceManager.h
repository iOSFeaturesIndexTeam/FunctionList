//
//  GIFProduceManager.h
//  GIFCreator
//
//  Created by BeautyHZ on 2017/4/25.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GIFProduceManager : NSObject

+ (void)createGIFWithImgs:(NSArray *)imgs outPath:(NSString *)outpath completionHandler:(void(^)(NSURL *temUrl))handler;

+ (void)praseGIFFromUrl:(NSURL *)url withCompeltionHandler:(void(^)(NSArray *imgs, CGFloat gifTime))handler;

@end
