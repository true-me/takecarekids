//
//  BaseViewController.h
//  DuoTin
//
//  Created by Jeffrey Ma  on 11/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DTPlayer;

@interface BaseViewController : UIViewController
- (void) setUpTitleView:(NSString*) title;

- (void) setUpLeftButton:(UIButton*) btn;
- (void) setUpRightButton:(UIButton*) btn;

- (void) setUpSecondTitleView:(NSString*) title;
- (void) didTapBackButton:(id)sender;
- (void) clickNowPlayingButton:(id)sender;
- (void) setUpTitleImageView:(NSString *)imageName;
@end
