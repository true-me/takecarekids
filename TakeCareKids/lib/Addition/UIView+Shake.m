//
//  UIView+Shake.m
//  loushitong
//
//  Created by 石瑞 on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Shake.h"

@implementation UIView (Shake)

#define SHAKE_DISTANCE 8
#define SHAKE_DURATION 0.06
#define SHAKE_REPEAT_COUNT 3.5

- (void)shakeLeftToCenter
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHAKE_DURATION];
    CGPoint pos = self.center;
    pos = CGPointMake(pos.x - SHAKE_DISTANCE, pos.y);
    self.center = pos;
    [UIView commitAnimations];
}

- (void)shakeBetweenLeftAndRight
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHAKE_DURATION];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:SHAKE_REPEAT_COUNT];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shakeLeftToCenter)];
    CGPoint pos = self.center;
    pos = CGPointMake(pos.x + SHAKE_DISTANCE * 2, pos.y);
    self.center = pos;
    [UIView commitAnimations];
}

- (void)shake
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:SHAKE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shakeBetweenLeftAndRight)];
    CGPoint pos = self.center;
    pos = CGPointMake(pos.x - SHAKE_DISTANCE, pos.y);
    self.center = pos;
    [UIView commitAnimations];
}

@end
