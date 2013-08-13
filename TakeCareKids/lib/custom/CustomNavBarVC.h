//
//  NavController.h
//  INCITY
//
//  Created by Jeffrey Ma on 8/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CustomNavBarDelegate <NSObject>
@optional
- (void)LeftButtonPress:(id)sender;
- (void)RightButtonPress:(id)sender;
@end


@interface CustomNavBarVC : UINavigationController

@property (nonatomic,retain) id<CustomNavBarDelegate> customdelegate;
@property (nonatomic,retain) UIImageView * navImage;
@property (nonatomic,retain) UIButton * leftNavButton;
@property (nonatomic,retain) UIButton * rightNavButton;
@property (nonatomic,retain) UILabel * titleLabel;

- (id) initWithRootViewController:(UIViewController *)rootViewController;
- (void )setupTitle:(NSString *)title;

- (void )rightButtonWithTitle:(NSString *)title withSelector:(SEL) selector onTarget:(id) target;
- (void )rightButtonWithImage:(UIImage *)image withSelector:(SEL) selector onTarget:(id) target;

- (void )leftButtonWithTitle:(NSString *)title withSelector:(SEL) selector onTarget:(id) target;
- (void )leftButtonWithImage:(UIImage *)image withSelector:(SEL) selector onTarget:(id) target;

@end

