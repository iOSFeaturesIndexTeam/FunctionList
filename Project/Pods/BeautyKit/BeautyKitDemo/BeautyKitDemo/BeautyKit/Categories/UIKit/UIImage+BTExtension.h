//
//  UIImage+BTExtension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/5.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeautyKitMacro.h"
#import "UIColor+BTExtension.h"
#import <CoreMedia/CMSampleBuffer.h>
typedef NS_ENUM(NSUInteger,KCDeviceRotateDirection) {
    KCDeviceRotateDirectionUp,
    KCDeviceRotateDirectionDown,
    KCDeviceRotateDirectionLeft,
    KCDeviceRotateDirectionRight,
    KCDeviceRotateDirectionUnknown
};
@interface UIImage (BTExtension)

/** 
 纯色图 
 */
+ (UIImage *)union_imageWithColor:(UIColor *)color;

/**
 高斯模糊图
 */
- (UIImage *)union_blurImage;

- (UIImage *)union_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

- (UIImage *)union_scale:(CGFloat)scale;

+ (UIImage *)union_imageScreenShotUsingContext:(BOOL)useContext;

/**
 把图片旋转到指定角度
 */
- (UIImage *)union_rotateWithDegrees:(CGFloat)degrees;

/**
 虚线框
 */
+ (UIImage*)union_imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

/**
 UIImage尺寸处理
 */
+ (UIImage *)union_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 resize
 */
- (void)union_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

/**
 将图片切成圆角图片
 */
- (UIImage *)union_imageWithRoundedSize:(CGSize)size radius:(NSInteger)r;

/**
 播放GIF图片，放到imageView里面自动播放
 */
+ (UIImage *)union_animatedImageWithAnimatedGIFData:(NSData *)theData;

/**
 取图片上某点的颜色值
 */
- (UIColor *)union_colorAtPixel:(CGPoint)point;

/**
 创建单色颜色值Image
 */
+ (UIImage *)union_imageWithSolidColor:(UIColor *)color size:(CGSize)size;


#pragma mark - 0.0.2 扩展
- (UIImage *)clipImageInRect:(CGRect)rect;
/**
 将文本绘制进 图片
 
 @param image 原图
 @param text 文本
 @param point 绘制坐标
 @param attributes 文本属性
 @return 成效图
 */
+ (UIImage *)createImage:(UIImage *)image drawText:(NSString *)text drawPoint:(CGPoint)point attributes:(NSDictionary *)attributes;
//+ (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize;

+ (UIImage *)un_imageWithColorHex:(NSInteger)colorHex alpha:(CGFloat)alpha;

/**
 将图片画入图片
 
 @param t1 原图
 @param t2 画入图
 @param rect 画入位置
 @return 合成图
 */
+ (UIImage *)createShareImage:(UIImage *)t1 contextImage:(UIImage *)t2 drawRect:(CGRect)rect;

/** 水平镜像*/
- (UIImage*)levelMirror;

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
+ (UIImage *)deepCopyImg:(UIImage *)img;
/** 垂直镜像*/
- (UIImage *)verticalMirror;
- (UIImage *)imgScaleAspectFillWithSize:(CGSize)size;
- (UIImage *)imgResize:(CGSize)size;
- (UIImage *)imgScaleAspectFitWithSize:(CGSize)size;
/** 通过UIDevice 方向 旋转图片*/
- (UIImage *)rorateForDeviceOrientation:(KCDeviceRotateDirection)deviceOrientation;

@end
