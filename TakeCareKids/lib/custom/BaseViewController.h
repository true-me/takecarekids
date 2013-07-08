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

- (void) setupLeftButton:(UIButton*) btn;
- (void) setupRightButton:(UIButton*) btn;

- (void) setupSecondTitleView:(NSString*) title;
- (void) didTapBackButton:(id)sender;
- (void) setupTitleImageView:(NSString *)imageName;

- (void )setupTitle:(NSString *)title;
- (void )rightButtonWithTitle:(NSString *)title withSelector:(SEL) selector onTarget:(id) target;
- (void )rightButtonWithImage:(UIImage *)image withSelector:(SEL) selector onTarget:(id) target;

- (void )leftButtonWithTitle:(NSString *)title withSelector:(SEL) selector onTarget:(id) target;
- (void )leftButtonWithImage:(UIImage *)image withSelector:(SEL) selector onTarget:(id) target;

@end
