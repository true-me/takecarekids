//
//  CustomNavBarVC.m
//
//
//  Created by Jeffrey Ma on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomNavBarVC.h"

@implementation CustomNavBarVC
@synthesize customdelegate = _customdelegate;
@synthesize backImageView = _backImageView;
@synthesize leftNavButton = _leftNavButton;
@synthesize rightNavButton = _rightNavButton;
@synthesize titleLabel = _titleLabel;

- (void)dealloc
{
    [_customdelegate release];
    [_backImageView release];
    [_leftNavButton  release];
    [_rightNavButton release];
    [_titleLabel release];
    [_terminalMenu release];
    [super dealloc];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        
        [self setBackImage:nil];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    if (REUIKitIsFlatMode()) {
        [self.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:0/255.0 green:213/255.0 blue:161/255.0 alpha:1]];
        self.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    }
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"13300000000"
                                                    subtitle:nil
                                                       image:[UIImage imageNamed:@"Icon_Profile"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          
//                                                          HomeViewController *controller = [[HomeViewController alloc] init];
//                                                          [weakSelf setViewControllers:@[controller] animated:NO];
                                                      }];
//    homeItem.textAlignment = NSTextAlignmentLeft;
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"1331111111"
                                                       subtitle:nil
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"13322222222"
                                                        subtitle:nil
                                                           image:[UIImage imageNamed:@"Icon_Profile"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                  
                                                          }];
    
//    activityItem.badge = @"12";
    
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"1344444444"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);                                                         }];
    
    // You can also assign a custom view for any particular item
    // Uncomment the code below and add `customViewItem` to `initWithItems` array, for example:
    // self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, customViewItem]]
    //
    /*
     UIView *customView = [[UIView alloc] init];
     customView.backgroundColor = [UIColor blueColor];
     customView.alpha = 0.4;
     REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
     NSLog(@"Tap on customView");
     }];
     */
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    profileItem.tag = 3;
    
    self.terminalMenu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
    
    // Background view
    //
    self.terminalMenu.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.terminalMenu.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.terminalMenu.backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
    
    //self.menu.imageAlignment = REMenuImageAlignmentRight;
    //self.menu.closeOnSelection = NO;
    //self.menu.appearsBehindNavigationBar = NO; // Affects only iOS 7
    if (!REUIKitIsFlatMode()) {
        self.terminalMenu.cornerRadius = 4;
        self.terminalMenu.shadowRadius = 4;
        self.terminalMenu.shadowColor = [UIColor blackColor];
        self.terminalMenu.shadowOffset = CGSizeMake(0, 1);
        self.terminalMenu.shadowOpacity = 1;
    }
    
    // Blurred background in iOS 7
    //
    //self.menu.liveBlur = YES;
    //self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    //self.menu.liveBlurTintColor = [UIColor redColor];
    
    self.terminalMenu.imageOffset = CGSizeMake(5, -1);
    self.terminalMenu.waitUntilAnimationIsComplete = NO;
    self.terminalMenu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
}

- (void)toggleMenu
{
    if (self.terminalMenu.isOpen)
        return [self.terminalMenu close];
    
    [self.terminalMenu showFromNavigationController:self];
}


#pragma mark - title
- (void )setupTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectZero;//CGRectMake(0, 0, 320, 44);
    //    titleLabel.center = CGPointMake(160, 25);
//    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    if([self.viewControllers lastObject])
    {
        UIViewController * vc = [self.viewControllers lastObject];
        vc.navigationItem.titleView = titleLabel;
    }
    self.titleLabel = titleLabel;
    
    [titleLabel release];
}

- (void )setupTitle:(NSString *)title action:(SEL) selector target:(id) target
{
    UIButton *button = [self buttonBuilder:CGRectMake(0,0, 120, 30) title:title alignment:NSTextAlignmentCenter target:(id)target action:(SEL)selector normalImage:nil highlightImage:nil];
    
    if([self.viewControllers lastObject])
    {
        UIViewController * vc = [self.viewControllers lastObject];
        vc.navigationItem.titleView = button;
    }
}

#pragma mark - left button
- (void)LeftButton:(id)sender
{
    if ([_customdelegate respondsToSelector:@selector(LeftButtonPress:)])
    {
        [_customdelegate LeftButtonPress:sender];
    }
}
- (void )leftButtonWithImage:(UIImage *)image action:(SEL) selector onTarget:(id) target
{
    if (image)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 34, 29);
        btn.backgroundColor = [UIColor clearColor];
        //        UIImage *bgimg =  [[UIImage imageNamed:@"nav-btn-bg.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:14];
        //        [bgimg drawInRect:CGRectMake(0, 0, 34, 29)];
        [btn setBackgroundImage:[UIImage imageNamed:@"nav-btn-bg.png"] forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        self.leftNavButton = btn;
        
        UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.leftNavButton];
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            vc.navigationItem.leftBarButtonItem = sendButtonItem;
        }
        [sendButtonItem release];
    }
    else
    {
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            [vc.navigationItem.leftBarButtonItem.customView setHidden:YES];
        }
    }
    
}


- (void )leftButtonWithImage:(UIImage *)image size:(CGSize) size action:(SEL) selector target:(id) target
{
    if (image)
    {
        self.leftNavButton = [self buttonBuilder:CGRectMake(0,0,size.width, size.height) title:nil alignment:NSTextAlignmentCenter target:(id)target action:(SEL)selector normalImage:image highlightImage:nil];
        
        UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.leftNavButton];
        
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            vc.navigationItem.leftBarButtonItem = sendButtonItem;
        }
        [sendButtonItem release];
    }
    else
    {
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            [vc.navigationItem.leftBarButtonItem.customView setHidden:YES];
        }
    }
}

- (void )leftButtonWithTitle:(NSString *)title action:(SEL) selector onTarget:(id) target
{
    if (title)
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
        self.leftNavButton = btn;
        UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.leftNavButton];
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            vc.navigationItem.leftBarButtonItem = sendButtonItem;
        }
        [sendButtonItem release];
    }
    else
    {
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            [vc.navigationItem.leftBarButtonItem.customView setHidden:YES] ;
        }
    }
}

#pragma mark - right button

- (void )rightButtonWithTitle:(NSString *)title action:(SEL)selector onTarget:(id)target
{
    if (title)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 29);
        btn.backgroundColor = [UIColor clearColor];
        UIImage *bgimg =  [[UIImage imageNamed:@"nav-btn-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        //        [bgimg drawInRect:CGRectMake(0, 0, 42, 44)];
        [btn setBackgroundImage:bgimg forState:UIControlStateNormal];
        //[btn setBackgroundImage:bgimg forState:UIControlStateHighlighted];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        self.rightNavButton = btn;
        UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            vc.navigationItem.rightBarButtonItem = sendButtonItem;
        }
        [sendButtonItem release];
    }
    else
    {
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            [vc.navigationItem.rightBarButtonItem.customView setHidden:YES];
        }
    }
}
- (void )rightButtonWithImage:(UIImage *)image size:(CGSize) size action:(SEL) selector target:(id) target
{
    if (image)
    {
        self.rightNavButton = [self buttonBuilder:CGRectMake(0,0,size.width, size.height) title:nil alignment:NSTextAlignmentCenter target:(id)target action:(SEL)selector normalImage:image highlightImage:nil];
        
        UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
        
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            vc.navigationItem.rightBarButtonItem = sendButtonItem;
        }
        [sendButtonItem release];
    }
    else
    {
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            [vc.navigationItem.rightBarButtonItem.customView setHidden:YES];
        }
    }
}

- (void )rightButtonWithImage:(UIImage *)image action:(SEL) selector onTarget:(id) target
{
    if (image)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, -1, 42, 44);
        btn.backgroundColor = [UIColor clearColor];
        //UIImage *bgimg =  [[UIImage imageNamed:@"nav-btn-bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        //[bgimg drawInRect:CGRectMake(0, 0, 42, 44)];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"nav-btn-bg.png"] forState:UIControlStateNormal];
        //        [btn setBackgroundImage:bgimg forState:UIControlStateHighlighted];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        self.rightNavButton = btn;
        UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            vc.navigationItem.rightBarButtonItem = sendButtonItem;
        }
        [sendButtonItem release];
    }
    else
    {
        if([self.viewControllers lastObject])
        {
            UIViewController * vc = [self.viewControllers lastObject];
            [vc.navigationItem.rightBarButtonItem.customView setHidden:YES] ;
        }
    }
}



- (void)RightButton:(id)sender {
    if ([_customdelegate respondsToSelector:@selector(RightButtonPress:)]) {
        [_customdelegate RightButtonPress:sender];
    }
}
//#pragma mark - other
//-(void) setBadge:(BOOL) show withNumber:(NSInteger) num
//{
//    if([self.viewControllers lastObject])
//    {
//        UIViewController * vc = [self.viewControllers lastObject];
//        UIBarButtonItem *leftItem = vc.navigationItem.leftBarButtonItem;
//        UIView *customview = leftItem.customView;
//        if (customview)
//        {
//            UIView * v = [customview viewWithTag:BADGE_NUM_TAG];
//            if (v)
//            {
//                [v setHidden:!show];
//                UILabel *lbl = (UILabel *)v;
//                lbl.text = [NSString stringWithFormat:@"%d", num];
//            }
//            else
//            {
//                CGRect frame = customview.frame;
//                
//                UILabel *lblUnread = [[UILabel alloc] init];
//                lblUnread.tag = BADGE_NUM_TAG;
//                lblUnread.frame = CGRectMake(frame.size.width - 15, 0, 15, 15);
//                lblUnread.backgroundColor = [UIColor clearColor];
//                lblUnread.textAlignment = UITextAlignmentCenter;
//                lblUnread.font = [UIFont boldSystemFontOfSize:12];
//                lblUnread.textColor = [UIColor redColor];
//                lblUnread.text = [NSString stringWithFormat:@"%d", num];
//                [customview addSubview:lblUnread];
//                [customview bringSubviewToFront:lblUnread];
//                [lblUnread release];
//            }
//        }
//    }
//}
//
//-(void) setBadge:(BOOL) show
//{
//    if([self.viewControllers lastObject])
//    {
//        UIViewController * vc = [self.viewControllers lastObject];
//        UIBarButtonItem *leftItem = vc.navigationItem.leftBarButtonItem;
//        UIView *customview = leftItem.customView;
//        if (customview)
//        {
//            UIView * v = [customview viewWithTag:BADGE_NUM_TAG];
//            if (v)
//            {
//                [v setHidden:!show];
//                
//            }
//            else
//            {
//                CGRect frame = customview.frame;
//                UIImageView *badgeIcon = [[UIImageView alloc] init];
//                badgeIcon.frame = CGRectMake(frame.size.width - 15, 9, 9, 9);
//                badgeIcon.image =[[UIImage imageNamed:@"badge_dot.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:10];
//                badgeIcon.tag = BADGE_TAG;
//                //                badgeIcon.hidden = show;
//                [customview addSubview:badgeIcon];
//                [customview bringSubviewToFront:badgeIcon];
//                [badgeIcon release];
//            }
//        }
//    }
//}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    DLog(@"hudWasHidden:%d",  [hud retainCount]);
	[hud removeFromSuperview];
    DLog(@"hudWasHidden:%d",  [hud retainCount]);
	hud = nil;
    DLog(@"hudWasHidden:%d",  [hud retainCount]);
    
}

- (UIButton *)buttonBuilder:(CGRect)frame title:title alignment:(NSTextAlignment) alignment target:(id)target action:(SEL)action normalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (title && [title length] > 0)
    {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.frame = button.bounds;
        //    lbl.center = CGPointMake(160, 25);
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = alignment;
        lbl.font = [UIFont boldSystemFontOfSize:14];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.text = title;
        //    [lbl sizeToFit];
        [button addSubview:lbl];
        [lbl release];
    }
    
    return button;
}

-(void) setBackImage:(UIImage *) image
{
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGSize titleSize = self.navigationBar.bounds.size;  //获取Navigation Bar的位置和大小
    
    UIImage *backgroundImage = nil;
    
    if(image)
    {
        backgroundImage =  [self scaleToSize:image size:titleSize];//设置图片的大小与Navigation Bar相同
    }
    else
    {
        //        backgroundImage = [[UIImage imageNamed:@"nav-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        //        [image drawInRect:CGRectMake(0, 0, titleSize.width, titleSize.height)];
        backgroundImage = [self scaleToSize:[UIImage imageNamed:@"nav-bg.png"] size:titleSize];//设置图片的大小与Navigation Bar相同
    }
    if (self.backImageView)
    {
        [self.backImageView removeFromSuperview];
    }
    self.backImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    if(systemVersion>=5.0)
    {
        [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];  //设置背景
    }
    else
    {
        
        [self.navigationBar insertSubview:self.backImageView atIndex:1];
    }
    
}


//调整图片大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end

@implementation UINavigationBar (CustomBackground)      //重写navbar
//
- (UIImage *)barBackground
{
    UIImage *img =  [[UIImage imageNamed:@"nav-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    return img;
}
//
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
    UIImage *image =  [[UIImage imageNamed:@"nav-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

////定义高度
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    BOOL isCustomNavBarVC = NO;
//    for (UIView* next = [self superview]; next; next = next.superview)
//    {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]])
//        {
//            if ([[nextResponder clazzName] isEqualToString:NSStringFromClass([CustomNavBarVC class])])
//            {
//                DLog(@"controller=%@, %@", [nextResponder clazzName], NSStringFromClass([CustomNavBarVC class]));
//                isCustomNavBarVC = YES;
//                break;
//            }
//        }
//    }
//
//    if (isCustomNavBarVC)
//    {
//        for (UIView *subv in self.subviews)
//        {
//            NSString *str = [subv clazzName];
//            DLog(@"class=%@, x.1=%f", str, subv.frame.origin.x);
//
////            if([str isEqualToString:@"UINavigationItemView"]
////               || [str isEqualToString:@"UILabel"]
////               || [str isEqualToString:@"UIView"])
////            {}
////
//            if([str isEqualToString:@"UINavigationItemButtonView"]
//               || [str isEqualToString:@"UIButton"])
//            {
//                CGRect frame = subv.layer.frame;
//                if (frame.origin.x <160.0f)
//                {
//                    //修正左侧侧位置
//                    frame.origin.y = 10.0f;
//                }
//                else
//                {
//                    //修正右侧按钮
//                    frame.origin.y = 10.0f;
////                    frame.size.width = 320.0f- 277.0f;
//                }
////                frame.size.height = 44.0f;
//                [subv setFrame:frame];
//           }
//        }
//    }
//
//}

@end