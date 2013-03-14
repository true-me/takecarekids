//
//  AppDelegate.m
//  TakeCareKids
//
//  Created by Jeffrey Ma on 2/16/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation AppDelegate
@synthesize tabBarController;
@synthesize customTabbarController;
- (void)dealloc
{
    [_window release];
    [tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
//    UIViewController *viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
//    UIViewController *viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
//    QieziViewController *viewController3 = [[[QieziViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
//    BMViewController *viewController4 = [[[BMViewController alloc] initWithNibName:@"BMViewController" bundle:nil] autorelease];
//    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
//    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3, viewController4];
//    self.window.rootViewController = self.tabBarController;
    
    // 地图
    self.customTabbarController = [[[CustomTabbarController alloc] init] autorelease];
    //    self.customTabbarController.viewControllers = [NSArray arrayWithObjects:nav1, nav2,nav3,nav4,nav5,nil];
    self.customTabbarController.selectedIndex = 0;
    self.window.rootViewController = self.customTabbarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
