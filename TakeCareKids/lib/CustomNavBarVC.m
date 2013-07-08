//
//  NavController.m
//  INCITY
//
//  Created by Jeffrey Ma on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomNavBarVC.h"

@implementation CustomNavBarVC
@synthesize customdelegate = _customdelegate;
@synthesize navImage = _navImage;
@synthesize leftNavButton = _leftNavButton;
@synthesize rightNavButton = _rightNavButton;
@synthesize titleLabel = _titleLabel;

- (void)dealloc
{
    [_customdelegate release];
    [_navImage release];
    [_leftNavButton  release];
    [_rightNavButton release];
    [_titleLabel release];
    [super dealloc];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        ;
    }
    return self;
}
- (void )setupTitle:(NSString *)title
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 0, 220, 50);
    _titleLabel.center = CGPointMake(160, 25);
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1.0f];
    _titleLabel.text = title;
    if([self.viewControllers lastObject])
    {
        UIViewController * vc = [self.viewControllers lastObject];
        vc.navigationItem.titleView = _titleLabel;
    }
//    [_titleLabel release];
}

- (void )rightButtonWithTitle:(NSString *)title withTarget:(SEL) selector onTarget:(id) target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, -1, 42, 44);
    btn.backgroundColor = [UIColor clearColor];
    UIImage *bgimg =  [[UIImage imageNamed:@"topbar_r_pressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [bgimg drawInRect:CGRectMake(0, 0, 42, 44)];
    [btn setBackgroundImage:bgimg forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    btn.layer.borderWidth = 1.0f;

    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *line = [[UIImageView alloc] init];
    line.frame = CGRectMake(-3, -1, 3, 44);
    line.backgroundColor = [UIColor clearColor];
    line.image = [UIImage imageNamed:@"topbar_line.png"];
    [btn addSubview:line];
    [line release];
    
    UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    if([self.viewControllers lastObject])
    {
        UIViewController * vc = [self.viewControllers lastObject];
        vc.navigationItem.rightBarButtonItem = sendButtonItem;
    }
    [sendButtonItem release];
}
- (void )leftButtonWithImage:(UIImage *)image withTarget:(SEL) selector onTarget:(id) target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.layer.borderWidth = 1.0f;
    btn.frame = CGRectMake(0, -1, 42, 44);
    btn.backgroundColor = [UIColor clearColor];
//    UIImage *bgimg =  [[UIImage imageNamed:@"topbar_l_pressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//    [bgimg drawInRect:CGRectMake(0, 0, 42, 44)];
    [btn setBackgroundImage:[UIImage imageNamed:@"topbar_l_pressed.png"] forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *line = [[UIImageView alloc] init];
    line.frame = CGRectMake(42, 0, 3, 44);
    line.backgroundColor = [UIColor clearColor];
    line.image = [UIImage imageNamed:@"topbar_line.png"];
    [btn addSubview:line];
    [line release];
    
    UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    if([self.viewControllers lastObject])
    {
        UIViewController * vc = [self.viewControllers lastObject];
        vc.navigationItem.leftBarButtonItem = sendButtonItem;
    }
    [sendButtonItem release];

}

- (void )rightButtonWithImage:(UIImage *)image withTarget:(SEL) selector onTarget:(id) target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, -1, 42, 44);
    btn.backgroundColor = [UIColor clearColor];
    UIImage *bgimg =  [[UIImage imageNamed:@"topbar_r_pressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [bgimg drawInRect:CGRectMake(0, 0, 42, 44)];
    [btn setBackgroundImage:bgimg forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *line = [[UIImageView alloc] init];
    line.frame = CGRectMake(-3, -1, 3, 50);
    line.backgroundColor = [UIColor clearColor];
    line.image = [UIImage imageNamed:@"topbar_line.png"];
    [btn addSubview:line];
    [line release];
    
    UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    if([self.viewControllers lastObject])
    {
        UIViewController * vc = [self.viewControllers lastObject];
        vc.navigationItem.rightBarButtonItem = sendButtonItem;
    }
    [sendButtonItem release];
}
- (void )leftButtonWithTitle:(NSString *)title withTarget:(SEL) selector onTarget:(id) target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, -1, 42, 44);
    btn.backgroundColor = [UIColor clearColor];
    UIImage *bgimg =  [[UIImage imageNamed:@"topbar_l_pressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [bgimg drawInRect:CGRectMake(0, 0, 42, 44)];
    [btn setBackgroundImage:bgimg forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

    UIImageView *line = [[UIImageView alloc] init];
    line.frame = CGRectMake(42, -1, 3, 50);
    line.backgroundColor = [UIColor clearColor];
    line.image = [UIImage imageNamed:@"topbar_line.png"];
    [btn addSubview:line];
    [line release];
    
    UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    if([self.viewControllers lastObject])
    {
        UIViewController * vc = [self.viewControllers lastObject];
        vc.navigationItem.leftBarButtonItem = sendButtonItem;
    }
    [sendButtonItem release];
}
- (void)LeftButton:(id)sender
{
    if ([_customdelegate respondsToSelector:@selector(LeftButtonPress:)])
    {
        [_customdelegate LeftButtonPress:sender];
    }
}

- (void)RightButton:(id)sender {
    if ([_customdelegate respondsToSelector:@selector(RightButtonPress:)]) {
        [_customdelegate RightButtonPress:sender];
    }
}

@end

@implementation UINavigationBar (CustomBackground)      //重写navbar

- (UIImage *)barBackground
{
    UIImage *img =  [[UIImage imageNamed:@"topbar_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    return img;
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
    UIImage *image =  [[UIImage imageNamed:@"topbar_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

//定义高度
- (void)layoutSubviews
{
    [super layoutSubviews];

//    
    for (UIView *subv in self.subviews)
    {
        NSString *str = [NSString stringWithUTF8String:object_getClassName(subv)];
        DLog(@"class=%@, x.1=%f", [subv getClassName], subv.frame.origin.x);
        if([str isEqualToString:@"UINavigationItemView"]
           || [str isEqualToString:@"UILabel"]
           )
        {

        }
        
        if([str isEqualToString:@"UIView"])
        {

        }
        
        if([str isEqualToString:@"UINavigationItemButtonView"]
           || [str isEqualToString:@"UIButton"]
           )
        {
            CGRect frame = subv.layer.frame;
            if (frame.origin.x <160.0f)
            {
                frame.origin.x = 0.0f;
            }
            else
            {
                frame.origin.x = 278.0f;
            }
 
            [subv setFrame:frame];
            subv.layer.borderColor = [[UIColor clearColor] CGColor];
            subv.layer.borderWidth = 1.0f;
//            break;
//            for (UIView *viewOne in subv.subviews)
//            {
//                NSString *viewName = [NSString stringWithUTF8String:object_getClassName(viewOne)];
//                if([viewName isEqualToString:@"UILabel"])
//               {
//
//               }
//            }

        }

    }
}

@end