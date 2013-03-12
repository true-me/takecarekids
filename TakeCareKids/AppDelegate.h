//
//  AppDelegate.h
//  TakeCareKids
//
//  Created by Jeffrey Ma on 2/16/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "BMViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
