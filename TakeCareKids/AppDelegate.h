//
//  AppDelegate.h
//  TakeCareKids
//
//  Created by Jeffrey Ma on 2/16/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "CustomTabbarController.h"
#import "ViewController.h"
#import "QieziViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) CustomTabbarController *customTabbarController;
@end
