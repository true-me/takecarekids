//
//  TabBarController.h
//  DuoTin
//
//  Created by Tom  on 10/31/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
//#import "MainController.h"
//#import "DownLoadMainController.h"
//#import "MoreInfoMainController.h"
//#import "MemberMainController.h"
//#import "ProgramMainController.h"

@interface TabBarController : UIViewController<UITabBarControllerDelegate, EGOImageViewDelegate>
{
    NSString *coverURL;
//    MainController *homeController;
}
@property(retain, nonatomic) NSString *coverURL;
//@property(retain, nonatomic) MainController *homeController;
@property(retain, nonatomic) UITabBarController *tabBarView;

@end
