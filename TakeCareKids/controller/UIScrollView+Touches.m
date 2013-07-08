//
//  UIScrollView+Touches.m
//  TakeCareKids
//
//  Created by Jeffrey Ma on 3/26/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import "UIScrollView+Touches.h"

@implementation UIScrollView (Touches)
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
    //NSLog(@"MyScrollView touch Began");
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}
@end
