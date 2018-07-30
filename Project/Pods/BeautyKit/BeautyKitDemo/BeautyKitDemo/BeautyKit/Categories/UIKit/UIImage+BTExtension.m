//
//  UIImage+BTExtension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/5.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "UIImage+BTExtension.h"
#import <Accelerate/Accelerate.h>
#import <ImageIO/ImageIO.h>

static CGFloat const union_degreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

@implementation UIImage (BTExtension)

+ (UIImage *)union_imageWithColor:(UIColor *)color {
    CGSize specSize = CGSizeMake(1, 1);
    CGRect rect = CGRectMake(0, 0, specSize.width, specSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (UIImage *)union_blurImage {
    return [self union_applyBlurWithRadius:10 tintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] saturationDeltaFactor:1.0 maskImage:nil];
}

- (UIImage *)union_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        //MH_Log (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        //MH_Log (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        //MH_Log (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(22 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *)union_scale:(CGFloat)scale {
    return [UIImage imageWithCGImage:self.CGImage scale:scale orientation:UIImageOrientationUp];
}

+ (UIImage *)union_imageScreenShotUsingContext:(BOOL)useContext {
    UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        if ((![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])){
            if (CGRectEqualToRect(window.bounds, CGRectZero)){
                continue;
            }
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            if (useContext) {
                [[window layer] renderInContext:context];
            } else {
                if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
                    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
                } else {
                    [[window layer] renderInContext:context];
                }
            }
            CGContextRestoreGState(context);
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)union_rotateWithDegrees:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(union_degreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, union_degreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)union_imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 5, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)union_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    CGFloat wAspect = newSize.width / image.size.width;
    CGFloat hAspect = newSize.height / image.size.height;
    
    CGFloat aspect = MAX(hAspect, wAspect);
    newSize = CGSizeMake(image.size.width*aspect, image.size.height*aspect);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)union_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
    CGRect drawRect;
    CGSize size = self.size;
    
    switch (contentMode){
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleToFill:{
            // nothing to do
            [self drawInRect:rect];
            return;
        }
        case UIViewContentModeScaleAspectFit:{
            CGFloat factor;
            
            if (size.width<size.height){
                factor = rect.size.height / size.height;
            }else{
                factor = rect.size.width / size.width;
            }
            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);
            
            // otherwise same as center
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
        case UIViewContentModeScaleAspectFill:{
            CGFloat factor;
            
            if (size.width<size.height){
                factor = rect.size.width / size.width;
            }else{
                factor = rect.size.height / size.height;
            }
            
            size.width = roundf(size.width * factor);
            size.height = roundf(size.height * factor);
            
            // otherwise same as center
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeCenter:{
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTop:{
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  rect.origin.y-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottom:{
            drawRect = CGRectMake(roundf(CGRectGetMidX(rect)-size.width/2.0f),
                                  rect.origin.y-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeLeft:{
            drawRect = CGRectMake(rect.origin.x,
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeRight:{
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  roundf(CGRectGetMidY(rect)-size.height/2.0f),
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTopLeft:{
            drawRect = CGRectMake(rect.origin.x,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeTopRight:{
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  rect.origin.y,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottomLeft:{
            drawRect = CGRectMake(rect.origin.x,
                                  CGRectGetMaxY(rect)-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
        case UIViewContentModeBottomRight:{
            drawRect = CGRectMake(CGRectGetMaxX(rect)-size.width,
                                  CGRectGetMaxY(rect)-size.height,
                                  size.width,
                                  size.height);
            break;
        }
            
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // clip to rect
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    // draw
    [self drawInRect:drawRect];
    
    CGContextRestoreGState(context);
}

- (UIImage *)union_imageWithRoundedSize:(CGSize)size radius:(NSInteger)r{
    int w = size.width;
    int h = size.height;
    
    UIImage *img = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapAlphaInfoMask|kCGBitmapByteOrderMask|kCGBitmapByteOrderDefault);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    union_addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

+ (UIImage *)union_animatedImageWithAnimatedGIFData:(NSData *)data {
    return union_animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL));
}

- (UIColor *)union_colorAtPixel:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIImage *)union_imageWithSolidColor:(UIColor *)color size:(CGSize)size {
    NSParameterAssert(color);
    NSAssert(!CGSizeEqualToSize(size, CGSizeZero), @"Size cannot be CGSizeZero");
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

static void union_addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight){
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0){
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

static int union_delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        CFRelease(properties);
        if (gifProperties) {
            CFNumberRef const number = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
            delayCentiseconds = (int)lrint([(__bridge id)number doubleValue] * 100);
        }
    }
    return delayCentiseconds;
}

static void union_createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = union_delayCentisecondsForImageAtIndex(source, i);
    }
}

static int union_sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int union_pairGCD(int a, int b) {
    if (a < b)
        return union_pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int union_vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        // Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
        gcd = union_pairGCD(values[i], gcd);
    }
    return gcd;
}

static UIImage *union_animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    union_createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = union_sum(count, delayCentiseconds);
    NSArray *const frames = union_frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    union_releaseImages(count, images);
    return animation;
}

static NSArray *union_frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = union_vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void union_releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage *union_animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef source) {
    if (source) {
        UIImage *const image = union_animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

#pragma mark - 0.0.2
- (UIImage *)clipImageInRect:(CGRect)rect
{
    if (!self) {
        return nil;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}
+ (UIImage *)createImage:(UIImage *)image drawText:(NSString *)text drawPoint:(CGPoint)point attributes:(NSDictionary *)attributes{
    UIImage *sourceImage = image;
    CGSize imageSize;
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    
    [text drawAtPoint:point withAttributes:attributes];
    //返回绘制的新图形
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)deepCopyImg:(UIImage *)img{
    return [UIImage imageWithData:UIImagePNGRepresentation(img)];
}

+ (UIImage *)un_imageWithColorHex:(NSInteger)colorHex alpha:(CGFloat)alpha
{
    return [[UIColor un_colorWithHex:colorHex alpha:alpha] union_colorImage];
}
+ (UIImage *)createShareImage:(UIImage *)t1 contextImage:(UIImage *)t2 drawRect:(CGRect)rect
{
    {
        UIImage *sourceImg =[t1 verticalMirror];
        UIImage *targetImg = [[t2 imgResize:rect.size] verticalMirror];
        CGSize sz = [sourceImg size];
        CGSize sz_t = [targetImg size];
        CGImageRef imageLeft = CGImageCreateWithImageInRect([sourceImg CGImage], CGRectMake(0, 0, sz.width, sz.height));//获取图片左侧部分
        CGImageRef imageRight = CGImageCreateWithImageInRect([targetImg CGImage], CGRectMake(0, 0, sz_t.width, sz_t.height));//获取图片右侧部分
        UIGraphicsBeginImageContext(CGSizeMake(sz.width, sz.height));//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        //绘制图片  con:绘制图片的上下文  CGRectMake:图片的原点和大小  imageLeft:当前的CGImage
        CGContextDrawImage(con, CGRectMake(0, 0, sz.width, sz.height), imageLeft);
        CGContextDrawImage(con, rect, imageRight);
        UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageLeft);
        CGImageRelease(imageRight);
        return im;
    }
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (UIImage*)levelMirror
{
    UIImage *sourceImage = self;
    
    CIImage *coreImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    UIImage *imgMirror = [UIImage imageWithCIImage:coreImage scale:sourceImage.scale orientation:UIImageOrientationUpMirrored];
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    [imgMirror drawInRect:rect];
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newimage;
}

- (UIImage *)verticalMirror{
    if (!self) {
        return nil;
    }
    const CGSize size = CGSizeMake((int)(self.size.width), (int)(self.size.height));
    const size_t bitsPerComponent = 8;
    const size_t bytesPerRow = size.width * 4;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context =
    CGBitmapContextCreate(NULL, size.width, size.height,
                          bitsPerComponent, bytesPerRow,
                          colorSpaceRef,
                          kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpaceRef);
    if(NULL == context) {
        CGContextRelease(context);
        return nil;
    }
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0 alpha:0] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextDrawImage(context,
                       CGRectMake(0,0,self.size.width,self.size.height),
                       [self CGImage]);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:newImage];
    CGContextRelease(context);
    CGImageRelease(newImage);
    
    return result;
}

- (UIImage *)rorateForDeviceOrientation:(KCDeviceRotateDirection)deviceOrientation{
    if (!self) {
        return nil;
    }
    CGSize size;
    const size_t bitsPerComponent = 8;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = nil;
    CGFloat rotate_angle = 0.;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    switch (deviceOrientation) {
            
            case KCDeviceRotateDirectionUnknown:
            case KCDeviceRotateDirectionUp:
            KCLog(@"螢幕直立");
        {
            size = CGSizeMake((int)(self.size.width), (int)(self.size.height));
            const size_t bytesPerRow = size.width * 4;
            
            context = CGBitmapContextCreate(NULL, size.width, size.height,
                                            bitsPerComponent, bytesPerRow,
                                            colorSpaceRef,
                                            kCGImageAlphaPremultipliedLast);
            rotate_angle = 0;
            translateX = 0;
            translateY = 0;
        }
            break;
            case KCDeviceRotateDirectionDown:
            KCLog(@"螢幕直立，上下顛倒");
        {
            size = CGSizeMake((int)(self.size.width), (int)(self.size.height));
            const size_t bytesPerRow = size.width * 4;
            context = CGBitmapContextCreate(NULL, size.width, size.height,
                                            bitsPerComponent, bytesPerRow,
                                            colorSpaceRef,
                                            kCGImageAlphaPremultipliedLast);
            rotate_angle =M_PI;
            translateX = -size.width;
            translateY = -size.height;
        }
            break;
            case KCDeviceRotateDirectionLeft:
            KCLog(@"螢幕向左橫置");
        {
            size = CGSizeMake((int)(self.size.height), (int)(self.size.width));
            const size_t bytesPerRow = size.width * 4;
            context = CGBitmapContextCreate(NULL, size.width, size.height,
                                            bitsPerComponent, bytesPerRow,
                                            colorSpaceRef,
                                            kCGImageAlphaPremultipliedLast);
            rotate_angle = M_PI_2;
            
            translateX = 0;
            translateY = -size.width;
            scaleY = size.width/size.height;
            scaleX = size.height/size.width;
        }
            break;
            case KCDeviceRotateDirectionRight:
            KCLog(@"螢幕向右橫置");
        {
            size = CGSizeMake((int)(self.size.height), (int)(self.size.width));
            const size_t bytesPerRow = size.width * 4;
            context = CGBitmapContextCreate(NULL, size.width, size.height,
                                            bitsPerComponent, bytesPerRow,
                                            colorSpaceRef,
                                            kCGImageAlphaPremultipliedLast);
            rotate_angle = M_PI_2 * 3;
            translateX = -size.height;
            translateY = 0;
            scaleY = size.width/size.height;
            scaleX = size.height/size.width;
        }
            break;
        default:
            KCLog(@"無法辨識");
        {
            rotate_angle= 0;
            translateX = 0;
            translateY = 0;
        }
            break;
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    if(NULL == context) {
        CGContextRelease(context);
        return nil;
    }
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0 alpha:0] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate_angle);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextDrawImage(context,
                       CGRectMake(0,0,size.width,size.height),
                       [self CGImage]);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:newImage];
    CGContextRelease(context);
    CGImageRelease(newImage);
    
    return result;
}
- (UIImage *)imgResize:(CGSize)size{
    if (!self) {
        return nil;
    }
    const size_t bitsPerComponent = 8;
    const size_t bytesPerRow = size.width * 4;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context =
    CGBitmapContextCreate(NULL, size.width, size.height,
                          bitsPerComponent, bytesPerRow,
                          colorSpaceRef,
                          kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpaceRef);
    if(NULL == context) {
        CGContextRelease(context);
        return nil;
    }
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0 alpha:0] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextDrawImage(context,
                       CGRectMake(0,0,size.width,size.height),
                       [self CGImage]);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:newImage];
    CGContextRelease(context);
    CGImageRelease(newImage);
    
    return result;
}
- (UIImage *)imgScaleAspectFillWithSize:(CGSize)size{
    if (!self) {
        return nil;
    }
    const size_t bitsPerComponent = 8;
    const size_t bytesPerRow = self.size.width * 4;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context =
    CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                          bitsPerComponent, bytesPerRow,
                          colorSpaceRef,
                          kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpaceRef);
    if(NULL == context) {
        CGContextRelease(context);
        return nil;
    }
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0 alpha:0] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextDrawImage(context,
                       CGRectMake(0,0,size.width,size.height),
                       [self CGImage]);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:newImage];
    CGContextRelease(context);
    CGImageRelease(newImage);
    
    return result;
}
- (UIImage *)imgScaleAspectFitWithSize:(CGSize)size{
    if (!self) {
        return nil;
    }
    const size_t bitsPerComponent = 8;
    const size_t bytesPerRow = size.width * 4;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context =
    CGBitmapContextCreate(NULL, size.width, size.height,
                          bitsPerComponent, bytesPerRow,
                          colorSpaceRef,
                          kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpaceRef);
    if(NULL == context) {
        CGContextRelease(context);
        return nil;
    }
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0 alpha:0] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    
    
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextDrawImage(context,
                       CGRectMake(0,0,self.size.width,self.size.height),
                       [self CGImage]);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:newImage];
    CGContextRelease(context);
    CGImageRelease(newImage);
    
    return result;
}

@end
