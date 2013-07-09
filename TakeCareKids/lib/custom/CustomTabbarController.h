//
//  CustomTabbarController.h
//  SmartCommunity
//
//  Created by Jeffrey Ma on 3/9/13.
//
//

#import <UIKit/UIKit.h>
#import "CustomNavBarVC.h"
#import "EGOImageView.h"
#import "ViewController.h"
#import "QieziViewController.h"
#import "EditViewController.h"

@interface CustomTabbarController : UITabBarController<UITabBarControllerDelegate, EGOImageViewDelegate, loginDelegate>
{
}
@property(retain, nonatomic) QieziViewController *mainController;
@property(retain, nonatomic) NSMutableArray *arrVC;

@end
