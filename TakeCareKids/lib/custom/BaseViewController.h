//
//  BaseViewController.h
//  DuoTin
//
//  Created by Jeffrey Ma  on 11/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CustomNavBarVC.h"

@protocol BaseViewDelegate <NSObject>
- (void)BackPrevious;
@end

@interface BaseViewController : UIViewController
- (void) setupTitleView:(NSString*) title;
- (void) setupTitle:(NSString *)title action:(SEL)selector target:(id) target;

- (void) setupLeftButton:(UIButton*) btn;
- (void) setupRightButton:(UIButton*) btn;

- (void) setupSecondTitleView:(NSString*) title;
- (void) didTapBackButton:(id)sender;
- (void) setupTitleImageView:(NSString *)imageName;

- (void )setupTitle:(NSString *)title;
- (void )rightButtonWithTitle:(NSString *)title action:(SEL) selector onTarget:(id) target;
- (void )rightButtonWithImage:(UIImage *)image action:(SEL) selector onTarget:(id) target;

- (void )leftButtonWithTitle:(NSString *)title action:(SEL) selector onTarget:(id) target;
- (void )leftButtonWithImage:(UIImage *)image action:(SEL) selector onTarget:(id) target;

-(void) showHUD:(NSString *) text;
-(void) hideHUD;
-(void) showHUD:(NSString *) text afterDelay:(CGFloat) delay;
-(void) hideHUD:(CGFloat) delay;

@end
