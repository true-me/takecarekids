//
//  CustomTabbarController.m
//  SmartCommunity
//
//  Created by Jeffrey Ma on 3/9/13.
//
//

#import "CustomTabbarController.h"
#import "CustomTabBarItem.h"

@interface CustomTabbarController ()
-(void)InitTabBar;
@end

@implementation CustomTabbarController
@synthesize mainController =_mainController;
@synthesize arrVC = _arrVC;

- (void)dealloc
{
    [_arrVC release];
    [super dealloc];
}

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
    
    NSMutableArray * arr =[[NSMutableArray alloc] initWithCapacity:5];
    self.arrVC = arr;
    [arr release];

    [self InitTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 用户登录
#pragma mark
#pragma mark Init Tabbar item
#pragma mark

-(void)InitTabBar
{
    [self.view setAlpha:1.0f];
    self.selectedIndex = 0;
    if(IS_IPHONE_5)
    {
        [self.view setFrame:CGRectMake(0,0,320,568)];
    } else
    {
        [self.view setFrame:CGRectMake(0,0,320,480)];
    }
    QieziViewController *vc1 = [[QieziViewController alloc] init];
    [self setTabBarItemWithVC:vc1 withTitle:@"首页" withImage:[UIImage imageNamed:@"tab-home.png"] withHlImage:[UIImage imageNamed:@"tab-home.png"]];
    
    QieziViewController *vc2 = [[QieziViewController alloc] init];
    [self setTabBarItemWithVC:vc2 withTitle:@"轨迹回放" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];

    QieziViewController *vc3 = [[QieziViewController alloc] init];
    [self setTabBarItemWithVC:vc3 withTitle:@"电子围栏" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    EditViewController *vc4 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc4 withTitle:@"亲情号码" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    EditViewController *vc5 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc5 withTitle:@"静默监听" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    EditViewController *vc6 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc6 withTitle:@"免打扰时间" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];

    EditViewController *vc7 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc7 withTitle:@"指定通话" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    EditViewController *vc8 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc8 withTitle:@"定时定位" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    EditViewController *vc9 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc9 withTitle:@"允许呼入号码" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    EditViewController *vc10 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc10 withTitle:@"SOS快捷键设置" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    EditViewController *vc11 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc11 withTitle:@"通知提醒" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    EditViewController *vc12 = [[EditViewController alloc] init];
    [self setTabBarItemWithVC:vc12 withTitle:@"短信允许" withImage:[UIImage imageNamed:@"tab-route.png"] withHlImage:[UIImage imageNamed:@"tab-route.png"]];
    
    [vc1  release];
    [vc2  release];
    [vc3  release];
    [vc4  release];
    [vc5  release];
    [vc6  release];
    [vc7  release];
    [vc8  release];
    [vc9  release];
    [vc10 release];
    [vc11 release];
    [vc12 release];
    
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
	self.viewControllers = self.arrVC;
    self.tabBar.opaque = YES;
	self.delegate=self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(viewController == [self.viewControllers objectAtIndex:0])
    {
        
    }
}
//-(void)LoginRecieved
//{
//    NSLog(@"登录成功!");
//    [self InitTabBar];
//}

//

-(void) setTabBarItemWithVC:(UIViewController *)vc
                  withTitle:title
                  withImage:(UIImage *)image
                withHlImage:(UIImage *)hlImage
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    vc.tabBarItem.tag = [self.arrVC count] + 1;
    vc.tabBarItem.title = title;
//    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    if (version >= 5.0)
    {
        [vc.tabBarItem setFinishedSelectedImage:image withFinishedUnselectedImage:hlImage];
    }
    else
    {
        vc.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:title normalImage:image highlightedImage:hlImage tag:vc.tabBarItem.tag] autorelease];
    }
    CustomNavBarVC *nav = [[CustomNavBarVC alloc] initWithRootViewController:vc];
    [self.arrVC addObject:nav];
    [nav release];
}

@end
