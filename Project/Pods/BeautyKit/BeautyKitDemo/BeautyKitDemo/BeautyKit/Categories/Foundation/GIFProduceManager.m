//
//  GIFProduceManager.m
//  GIFCreator
//
//  Created by BeautyHZ on 2017/4/25.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "GIFProduceManager.h"
#import "BeautyKitMacro.h"
@implementation GIFProduceManager

+ (void)createGIFWithImgs:(NSArray *)imgs outPath:(NSString *)outpath completionHandler:(void(^)(NSURL *temUrl))handler {
//    long stamp = [[NSDate date] timeIntervalSince1970];
    unlink([outpath UTF8String]);
    //配置gif属性
    CGImageDestinationRef destination;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)outpath, kCFURLPOSIXPathStyle, false);
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imgs.count, NULL);
    NSDictionary *frameDic = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.1],(NSString*)kCGImagePropertyGIFDelayTime, nil] forKey:(NSString*)kCGImagePropertyGIFDelayTime];
    
    NSMutableDictionary *gifParmdict = [NSMutableDictionary dictionaryWithCapacity:2];
    [gifParmdict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    [gifParmdict setObject:(NSString*)kCGImagePropertyColorModelRGB forKey:(NSString*)kCGImagePropertyColorModel];
    [gifParmdict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    [gifParmdict setObject:[NSNumber numberWithInt:0] forKey:(NSString*)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:gifParmdict forKey:(NSString*)kCGImagePropertyGIFDictionary];
    
    for (UIImage *dimage in imgs) {
        CGImageDestinationAddImage(destination, dimage.CGImage, (__bridge CFDictionaryRef)frameDic);
    }

    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    KCLog(@"animated GIF file created at %@", outpath);
    if (handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler([NSURL fileURLWithPath:outpath]);
        });
    }
}

+ (void)praseGIFFromUrl:(NSURL *)url withCompeltionHandler:(void(^)(NSArray *imgs, CGFloat gifTime))handler; {
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src =  CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        handler(frames, animationTime);
        CFRelease(src);
    }
    
}

@end
