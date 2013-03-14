//
//  NavController.m
//  INCITY
//
//  Created by Jeffrey Ma on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NavController.h"

@implementation NavController


@end

@implementation UINavigationBar (CustomBackground)      //重写navbar
- (void)viewDidLoad
{
    
}

- (UIImage *)barBackground{
    UIImage *img = [UIImage imageNamed:@"navbar-bg.png"];
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    return img;
    //return nil;
}

- (void)didMoveToSuperview{
    //iOS5 only
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
    }
}

//this doesn't work on iOS5 but is needed for iOS4 and earlier
- (void)drawRect:(CGRect)rect{
    //draw image
   // [[self barBackground] drawInRect:rect];
    
    UIImage *image = [UIImage imageNamed:@"navbar-bg.png"];

    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

//定义高度
- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGRect barFrame = self.frame;
////    barFrame.size.height = 44;
//    self.frame = barFrame;
//    
//    for (UIView *subv in self.subviews)
//    {
////        subv.layer.borderColor = [[UIColor blueColor] CGColor];
////        subv.layer.borderWidth = 1.0f;
//        NSString *str = [NSString stringWithUTF8String:object_getClassName(subv)];
//        CGRect titleframe = subv.frame;
//        //NSLog(@"class=%@, y=%f", str, subv.frame.origin.y);
//        if([str isEqualToString:@"UINavigationItemView"]
//           || [str isEqualToString:@"UILabel"]
//           )
//        {
//            titleframe.origin.y = 9.0f;
////            subv.layer.borderColor = [[UIColor blueColor] CGColor];
//        }
//        
//        if([str isEqualToString:@"UIView"])
//        {
//            //titleframe.origin.y = 7.0f;
////            subv.layer.borderColor = [[UIColor redColor] CGColor];
//        }
//        
//        if([str isEqualToString:@"UINavigationItemButtonView"]
//           || [str isEqualToString:@"UIButton"]
//           )
//        {
//            titleframe.origin.y = 4.0f;
////            subv.layer.borderColor = [[UIColor greenColor] CGColor];
//            for (UIView *viewOne in subv.subviews)
//            {
//                NSString *viewName = [NSString stringWithUTF8String:object_getClassName(viewOne)];
//                if([viewName isEqualToString:@"UILabel"])
//                   {
//                       UILabel *lbl = (UILabel *)viewOne;
//                       [lbl setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]];
//                       lbl.textColor = [UIColor whiteColor];
//                       lbl.shadowColor = [UIColor colorWithRed:0.0f
//                                                         green:0.0f
//                                                          blue:0.0f
//                                                         alpha:0.4f];
//                       lbl.shadowOffset = CGSizeMake(0.0f, 0.9f);
//                       lbl.backgroundColor = [UIColor clearColor];
//                       lbl.textAlignment = UITextAlignmentCenter;
//                   }
//
//            }
//
//        }
//        subv.frame = titleframe;
//    }
}

@end