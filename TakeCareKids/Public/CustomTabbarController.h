//
//  CustomTabbarController.h
//  SmartCommunity
//
//  Created by Jeffrey Ma on 3/9/13.
//
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "ViewController.h"
#import "QieziViewController.h"
#import "BMViewController.h"
#import "FirstViewController.h"
#import "NavController.h"
#import "TableDemoViewController.h"
#import "HomeRefreshableViewController.h"
#import "RefreshTableViewController.h"

@interface CustomTabbarController : UITabBarController<UITabBarControllerDelegate, EGOImageViewDelegate>
{
    NSString *coverURL;
    QieziViewController *mainController;
}
@property(retain, nonatomic) NSString *coverURL;
@property(retain, nonatomic) QieziViewController *mainController;
@end
