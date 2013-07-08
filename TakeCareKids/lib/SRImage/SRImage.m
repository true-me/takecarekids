//
//  SRImage.m
//  Discuz2
//
//  Created by rexshi on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SRImage.h"

@implementation SRImage

+ (UIImage *)cropWithImage:(UIImage *)image Rect:(CGRect)rect
{
    CGImageRef imageref = CGImageCreateWithImageInRect(image.CGImage, rect);
    image = [UIImage imageWithCGImage:imageref];
    return image;
}

+ (UIImage *)createScaleCenterImage:(UIImage *)image widthAndHeight:(float)widthAndHeight
{
    float width = image.size.width;
    float height = image.size.height;
    
    // 缩放
    float c = 0;
    if (width > height) {
        c = (width / height) * widthAndHeight;
    } else if (height > width) {
        c = (height / width) * widthAndHeight;
    } else {
        c = widthAndHeight;
    }
    c = ceilf(c);
    
    image = [[self class] transformWithLockedRatio:image width:c height:c rotate:YES];
    
    // 截取中间部分
    width = image.size.width;
    height = image.size.height;
    CGRect rect = CGRectZero;
    if (width != height) {
        if (width > height) {
            rect = CGRectMake((width - height) / 2, 0, height, height);
        } else {
            rect = CGRectMake(0, (height - width) / 2, width, width);
        }
        
        CGImageRef imageref = CGImageCreateWithImageInRect(image.CGImage, rect);
        image = [UIImage imageWithCGImage:imageref];
    }

    return image;
}

+ (UIImage*)transformWithLockedRatio:(UIImage *)image width:(CGFloat)width
                            height:(CGFloat)height rotate:(BOOL)rotate
{
    float sourceWidth = image.size.width;
    float sourceHeight = image.size.height;
    
    float widthRatio = width / sourceWidth;
    float heightRatio = height / sourceHeight;
    
    if (widthRatio >= 1 && heightRatio >= 1) {
        return image;
    }
    
    float destWidth, destHeight;
    if (widthRatio > heightRatio) {
        destWidth = sourceWidth * heightRatio;
        destHeight = height;
    } else {
        destWidth = width;
        destHeight = sourceHeight * widthRatio;
    }
    
    return [SRImage transform:image width:destWidth height:destHeight rotate:rotate];
}


+ (UIImage*)transform:(UIImage *)image width:(CGFloat)width
               height:(CGFloat)height rotate:(BOOL)rotate
{
    CGFloat destW = roundf(width);
    CGFloat destH = roundf(height);
    CGFloat sourceW = roundf(width);
    CGFloat sourceH = roundf(height);
    
    if (rotate) {
        if (image.imageOrientation == UIImageOrientationRight
            || image.imageOrientation == UIImageOrientationLeft) {
            sourceW = height;
            sourceH = width;
        }
    }
    
    CGImageRef imageRef = image.CGImage;
    
    int bytesPerRow = destW * (CGImageGetBitsPerPixel(imageRef) >> 3);

    CGContextRef bitmap = CGBitmapContextCreate(NULL, 
                                                destW, 
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef), 
                                                bytesPerRow, 
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    if (rotate) {
        if (image.imageOrientation == UIImageOrientationDown) {
            CGContextTranslateCTM(bitmap, sourceW, sourceH);
            CGContextRotateCTM(bitmap, 180 * (M_PI/180));
            
        } else if (image.imageOrientation == UIImageOrientationLeft) {
            CGContextTranslateCTM(bitmap, sourceH, 0);
            CGContextRotateCTM(bitmap, 90 * (M_PI/180));
            
        } else if (image.imageOrientation == UIImageOrientationRight) {
            CGContextTranslateCTM(bitmap, 0, sourceW);
            CGContextRotateCTM(bitmap, -90 * (M_PI/180));
        }
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

+(UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor
{
    UIGraphicsBeginImageContext(CGSizeMake(baseImage.size.width, baseImage.size.height));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    [theColor set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
//    CGContextDrawImage(ctx, area, baseImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    newImage = [SRImage transform:newImage width:baseImage.size.width height:baseImage.size.width rotate:NO];
    
    return newImage;
}

@end
