//
//  SRImage.h
//  Discuz2
//
//  Created by rexshi on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRImage : NSObject

// 裁剪
+ (UIImage *)cropWithImage:(UIImage *)image Rect:(CGRect)rect;

// 锁定比例缩放
+ (UIImage*)transformWithLockedRatio:(UIImage *)image width:(CGFloat)width
                            height:(CGFloat)height rotate:(BOOL)rotate;

// 缩放
+ (UIImage*)transform:(UIImage *)image width:(CGFloat)width
               height:(CGFloat)height rotate:(BOOL)rotate;

// 获取中心图像的缩略图
+ (UIImage *)createScaleCenterImage:(UIImage *)image
                     widthAndHeight:(float)widthAndHeight;

// 上色
+(UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor;

@end
