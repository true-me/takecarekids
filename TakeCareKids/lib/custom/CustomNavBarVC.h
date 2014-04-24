//
//  CustomNavBarVC.h
//
//
//  Created by Jeffrey Ma on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "REMenu.h"

@protocol CustomNavBarDelegate <NSObject>
@optional
- (void)LeftButtonPress:(id)sender;
- (void)RightButtonPress:(id)sender;

@end

@interface CustomNavBarVC : UINavigationController<MBProgressHUDDelegate>

@property (nonatomic,retain) id<CustomNavBarDelegate> customdelegate;
@property (nonatomic,retain) UIImageView * backImageView;
@property (nonatomic,retain) UIButton * leftNavButton;
@property (nonatomic,retain) UIButton * rightNavButton;
@property (nonatomic,retain) UILabel * titleLabel;
@property (nonatomic,retain) REMenu *terminalMenu;

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void )setupTitle:(NSString *)title;
- (void )setupTitle:(NSString *)title action:(SEL)selector target:(id) target;

- (void )rightButtonWithTitle:(NSString *)title action:(SEL) selector onTarget:(id) target;
- (void )leftButtonWithTitle:(NSString *)title action:(SEL) selector onTarget:(id) target;
- (void )leftButtonWithImage:(UIImage *)image action:(SEL) selector onTarget:(id) target;
- (void )rightButtonWithImage:(UIImage *)image action:(SEL) selector onTarget:(id) target;


- (void) leftButtonWithImage:(UIImage *)image size:(CGSize) size action:(SEL) selector target:(id) target;
- (void) rightButtonWithImage:(UIImage *)image size:(CGSize) size action:(SEL) selector target:(id) target;
- (void) setBackImage:(UIImage *) image;

- (void) toggleMenu;

//- (void) setBadge:(BOOL) show;
//-(void) setBadge:(BOOL) show withNumber:(NSInteger) num;
@end

