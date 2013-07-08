//
//  ZJTStatusBarAlertWindow.h
//  WishOrange
//
//  Created by Jeffrey Ma on 12-5-5.
//  Copyright (c) 2012年 LionTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJTStatusBarAlertWindow;

@interface ZJTStatusBarAlertWindow : NSObject{
    UIWindow        *_window;
    UILabel         *_label;
    UIImage         *_backgroundImage;
    UIImageView     *_backgroundImageView;
    
    NSString        *_displayString;
}

@property (nonatomic,retain)UIWindow        *window;
@property (nonatomic,retain)UILabel         *label;
@property (nonatomic,retain)UIImage         *backgroundImage;
@property (nonatomic,retain)UIImageView     *backgroundImageView;
@property (nonatomic,copy)  NSString        *displayString;

+(ZJTStatusBarAlertWindow *)getInstance;

-(void)showWithString:(NSString*)string;
-(void)hide;

@end
