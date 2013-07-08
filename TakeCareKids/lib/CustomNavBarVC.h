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
@property (nonatomic,strong) UIImageView * navImage;
@property (nonatomic,strong) UIButton * leftNavButton;
@property (nonatomic,strong) UIButton * rightNavButton;
@property (nonatomic,strong) UILabel * titleLabel;

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void )setupTitle:(NSString *)title;
- (void )rightButtonWithTitle:(NSString *)title withTarget:(SEL) selector onTarget:(id) target;
- (void )leftButtonWithTitle:(NSString *)title withTarget:(SEL) selector onTarget:(id) target;
- (void )leftButtonWithImage:(UIImage *)image withTarget:(SEL) selector onTarget:(id) target;
- (void )rightButtonWithImage:(UIImage *)image withTarget:(SEL) selector onTarget:(id) target;

@end

