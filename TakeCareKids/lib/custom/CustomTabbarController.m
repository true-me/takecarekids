//
//  CustomTabbarController.m
//  SmartCommunity
//
//  Created by Jeffrey Ma on 3/9/13.
//
//

#import "CustomTabbarController.h"
#import "CustomTabBarItem.h"
#import "CommonMethods.h"

@interface CustomTabbarController ()
-(void)InitTabBar;
@end

@implementation CustomTabbarController
@synthesize coverURL;
@synthesize mainController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self InitTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 用户登录
#pragma mark
-(void)LoginModalPresent
{
    LoginController *objLogin = [[LoginController alloc] init];
    objLogin.delegate = self;
    CustomNavBarVC *navController = [[[CustomNavBarVC alloc] initWithRootViewController:objLogin] autorelease];
    [self.tabBarController presentModalViewController:navController animated:YES];
    [objLogin release];
}
#pragma mark Init Tab Bar

-(void)InitTabBar
{
    [self.view setAlpha:1.0f];
    
    if(YES)
    {
        [self LoginModalPresent];
        
        //        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        //        [self.navigationController.view addSubview:HUD];
        //        HUD.labelText = @"请先登陆账号";
        //        [HUD showAnimated:YES whileExecutingBlock:^{
        //            sleep(2.0f);
        //        } completionBlock:^{
        //            [HUD removeFromSuperview];
        //            [HUD release];
        //            HUD = nil;
        //        }];
        //        return;
    }
    
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    self.selectedIndex = 0;
    if(IS_IPHONE_5)
    {
        [self.view setFrame:CGRectMake(0,0,320,568)];
    } else
    {
        [self.view setFrame:CGRectMake(0,0,320,480)];
    }
	NSMutableArray *arrViewsArray = [[NSMutableArray alloc] initWithCapacity:5];
	
    //Home Center Controller
	QieziViewController *vc1 = [[QieziViewController alloc] init];
    self.mainController = vc1;
    vc1.tabBarItem.tag = 1;
    vc1.tabBarItem.title = @"轨迹地图";
    if (version >= 5.0)
    {
        [vc1.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab-home.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-home.png"]];
    }
    else
    {
        vc1.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tab-home.png"] highlightedImage:[UIImage imageNamed:@"tab-home.png"] tag:1] autorelease];
    }
    //
	CustomNavBarVC  *nav1 = [[CustomNavBarVC alloc] initWithRootViewController:vc1];
    //    CGRect frame = navContrMainViewContoller.navigationBar.frame.origin.y;
    //    NSLog(@"navContrMainViewContoller.navigationBar.frame.origin.y=%f",nav1.navigationBar.frame.origin.y);
	[arrViewsArray addObject:nav1];
	[nav1 release];
	[vc1 release];
    //
    //Mall Center Controller
	EditViewController *vc2 = [[EditViewController alloc] init];
    vc2.tabBarItem.tag = 2;
    vc2.tabBarItem.title = @"个人中心";
    if (version >= 5.0)
    {
        [vc2.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab-route.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-route.png"]];
    }
    else
    {
        vc2.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tab-route.png"] highlightedImage:[UIImage imageNamed:@"tab-route.png"] tag:2] autorelease];
    }
	CustomNavBarVC *nav2 = [[CustomNavBarVC alloc] initWithRootViewController:vc2];
	[arrViewsArray addObject:nav2];
	[nav2 release];
	[vc2 release];
    
//    TableDemoViewController *vc3 = [[TableDemoViewController alloc] init];
//    vc3.tabBarItem.tag = 3;
//    if (version >= 5.0)
//    {
//        [vc3.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab-route.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-route.png"]];
//    }
//    else
//    {
//        vc3.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tab-route.png"] highlightedImage:[UIImage imageNamed:@"tab-route.png"] tag:2] autorelease];
//    }
//	NavController *nav3 = [[NavController alloc] initWithRootViewController:vc3];
//	[arrViewsArray addObject:nav3];
//	[nav3 release];
//	[vc3 release];
    
//    HomeRefreshableViewController *vc4 = [[HomeRefreshableViewController alloc] init];
//    vc4.tabBarItem.tag = 4;
//    if (version >= 5.0)
//    {
//        [vc4.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab-route.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-route.png"]];
//    }
//    else
//    {
//        vc4.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tab-route.png"] highlightedImage:[UIImage imageNamed:@"tab-route.png"] tag:2] autorelease];
//    }
//	NavController *nav4 = [[NavController alloc] initWithRootViewController:vc4];
//	[arrViewsArray addObject:nav4];
//	[nav4 release];
//	[vc4 release];
    
//    RefreshTableViewController *vc5 = [[RefreshTableViewController alloc] init];
//    vc5.tabBarItem.tag = 5;
//    if (version >= 5.0)
//    {
//        [vc5.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab-route.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-route.png"]];
//    }
//    else
//    {
//        vc5.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tab-route.png"] highlightedImage:[UIImage imageNamed:@"tab-route.png"] tag:2] autorelease];
//    }
//	NavController *nav5 = [[NavController alloc] initWithRootViewController:vc5];
//	[arrViewsArray addObject:nav5];
//	[nav5 release];
//	[vc5 release];

    
    //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-bg.png"]];
    CGRect frame;
    if (IS_IPHONE_5)
    {
        frame = CGRectMake(0, 431 + 86 , 320, 49);
    }
    else
    {
        // 300 435
        //frame = CGRectMake(0, 431, 320, 51);
        frame = CGRectMake(0, 431 , 320, 49);
    }
    
    [self.tabBar setFrame:frame];
	self.viewControllers = arrViewsArray;
    self.tabBar.opaque = YES;
    //
	self.delegate=self;
	//[self.navigationController setNavigationBarHidden:YES];
    //
	[arrViewsArray release];
//	[self.view addSubview:self.tabBarView.view];
//	[tabBar release];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(viewController == [self.viewControllers objectAtIndex:0])
    {
        
    }
}

@end
