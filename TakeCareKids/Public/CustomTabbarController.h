//
//  CustomTabbarController.h
//  SmartCommunity
//
//  Created by Jeffrey Ma on 3/9/13.
//
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "MainController.h"
#import "MallCenterController.h"
#import "WOCenterController.h"
#import "ELivingCenterController.h"
#import "MoreController.h"
#import "NavController.h"

@interface CustomTabbarController : UITabBarController<UITabBarControllerDelegate, EGOImageViewDelegate>
{
    NSString *coverURL;
    MainController *mainController;
}
@property(retain, nonatomic) NSString *coverURL;
@property(retain, nonatomic) MainController *mainController;
@end
