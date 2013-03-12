//
//  TabBarController.m
//  DuoTin
//
//  Created by Tom  on 10/31/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "TabBarController.h"
//#import "CustomTabBarItem.h"
#import "CommonMethods.h"

@interface TabBarController ()
-(void)InitTabBar;
@end

@implementation TabBarController

@synthesize tabBarView = _tabBarView;
@synthesize coverURL;
//@synthesize homeController;

#pragma mark 页面元素

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (!self.coverURL)
        {
            coverURL = [NSString stringWithFormat:@"http://www.duotin.com/api/cover1.png"];
        }
    }
    return self;
}

-(void)dealloc
{
    RELEASE_SAFELY(_tabBarView);
    RELEASE_SAFELY(coverURL);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitTabBar];
    //[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(InitTabBar) userInfo:nil repeats:NO];
    // 显示封面1
    NSRange range = [self.coverURL rangeOfString:@"/" options: NSBackwardsSearch];
    NSString *remoteFileName = nil;
    if (range.length > 0)
    {
        int location = range.location;
        int leight = range.length;
        remoteFileName = [NSString stringWithFormat:@"%@", [self.coverURL substringFromIndex:location + leight]];
    }
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentFileName = [[paths objectAtIndex:0] stringByAppendingPathComponent:remoteFileName];
    
    NSString *resourceFileName = [[NSBundle mainBundle] pathForResource:remoteFileName ofType:nil];
    EGOImageView *imageCover = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"cover1.png"]];
    imageCover.delegate = self;
    imageCover.frame = [UIScreen mainScreen].bounds;
    imageCover.tag = 8001;
    
    
    
    if ([CommonMethods isExistFile:resourceFileName])
    {
        // 文件存在。播放本地文件
        [imageCover setImage:[UIImage imageNamed:remoteFileName]];
    }
    else
    {
        imageCover.imageURL = [NSURL URLWithString:self.coverURL];
    }

    [self.tabBarView.view setAlpha:0.0f];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.fillMode = kCAFillModeForwards;
	animation.endProgress = 1;
	animation.removedOnCompletion = YES;
	animation.type = kCATransitionPush;
    //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
//    animation.subtype = kCATransitionFromRight;
    animation.subtype = kCATransitionFade;
    
    [self.view addSubview:imageCover];
    [imageCover release];
	[self.view.layer addAnimation:animation forKey:@"animation"];
    //[self InitTabBar];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop");

    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTabBar) userInfo:nil repeats:NO];
}
-(void) showTabBar
{
//    [self.homeController showUpdateView];
//    [self.tabBarView.view setAlpha:1.0f];
//    UIView *imgView = [self.view viewWithTag:(8001)];
//    [imgView setAlpha:0.0f];
//    [imgView removeFromSuperview];
}
- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    [imageView setDelegate:nil];
    return;
}
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    NSLog(@"imageViewFailedToLoadImage.Err= %@", error);    
    if (error.code == 406)
    {
        [imageView setDelegate:nil];
        return;
    }
    else
    {
        [imageView performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString:@"http://www.duotin.com/static/uploads/images/2012/12/bfb89feb5eb2bbb4d0bd7dc1407c7e35.jpg"] waitUntilDone:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Init Tab Bar

-(void)InitTabBar
{
//    [self.tabBarView.view setAlpha:0.0f];
//   
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    self.tabBarView.selectedIndex = 0;
//    if(IS_IPHONE_5)
//    {
//        [self.view setFrame:CGRectMake(0,0,320,568)];
//    } else
//    {
//        [self.view setFrame:CGRectMake(0,0,320,480)];
//    }
//	NSMutableArray *arrViewsArray = [[NSMutableArray alloc] initWithCapacity:5];
//	
//    //Landing View
////	MainController *objMain = [[MainController alloc] init];
////    self.homeController = objMain;
////    //[self.homeController.view setAlpha:0.0f];
////    [self.homeController hideUpdateView];
////    objMain.tabBarItem.tag = 1;
////    if (version >= 5.0)
////    {
////        [objMain.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabhome-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabhome.png"]];
////    }
////    else
////    {
////        objMain.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tabhome.png"] highlightedImage:[UIImage imageNamed:@"tabhome-selected.png"] tag:1] autorelease];
////    }
////    
////    
////	UINavigationController  *navContrMainViewContoller = [[UINavigationController alloc] initWithRootViewController:objMain];
//////    CGRect frame = navContrMainViewContoller.navigationBar.frame.origin.y;
////    NSLog(@"navContrMainViewContoller.navigationBar.frame.origin.y=%f",navContrMainViewContoller.navigationBar.frame.origin.y);
////	[arrViewsArray addObject:navContrMainViewContoller];
////	[navContrMainViewContoller release];
////	[objMain release];
////	
////    //Program View
////	ProgramMainController *objProgram = [[ProgramMainController alloc] init];
////    objProgram.tabBarItem.tag = 2;
////    if (version >= 5.0)
////    {
////        [objProgram.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabprog-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabprog.png"]];
////    }
////    else
////    {
////        objProgram.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tabprog.png"] highlightedImage:[UIImage imageNamed:@"tabprog-selected.png"] tag:2] autorelease];
////    }
////	UINavigationController *navContrPromotionViewContoller = [[UINavigationController alloc] initWithRootViewController:objProgram];
////	[arrViewsArray addObject:navContrPromotionViewContoller];
////	[navContrPromotionViewContoller release];
////	[objProgram release];
//	
//    
//    //Download Main View
//	DownLoadMainController *objDownloadMain = [[DownLoadMainController alloc] init];
//    objDownloadMain.tabBarItem.tag = 3;
//    if (version >= 5.0)
//    {
//        
//        [objDownloadMain.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabdownload-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabdownload.png"]];
//    }
//    else
//    {
//        objDownloadMain.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tabdownload.png"] highlightedImage:[UIImage imageNamed:@"tabdownload-selected.png"] tag:3] autorelease];
//    }
//	UINavigationController *navContrBusinessViewContoller = [[UINavigationController alloc] initWithRootViewController:objDownloadMain];
//	[arrViewsArray addObject:navContrBusinessViewContoller];
//	[navContrBusinessViewContoller release];
//	[objDownloadMain release];
//	
//    //Member Center Main View
//	MemberMainController *objMemberMain = [[MemberMainController alloc] init];
//
//    objMemberMain.tabBarItem.tag = 4;
//    if (version >= 5.0) {
//        [objMemberMain.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabmember-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabmember.png"]];
//    }
//    else
//    {
//        objMemberMain.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tabmember.png"] highlightedImage:[UIImage imageNamed:@"tabmember-selected.png"] tag:4] autorelease];
//    }
//	UINavigationController *navControInteractiveController = [[UINavigationController alloc] initWithRootViewController:objMemberMain];
//	[arrViewsArray addObject:navControInteractiveController];
//	[navControInteractiveController release];
//	[objMemberMain release];
//	
//	//More Info Main View
//    MoreInfoMainController *objMore = [[MoreInfoMainController alloc] init];
//    objMore.tabBarItem.tag =5;
//    if (version >= 5.0)
//    {
//        //当有新版本需要更新时给出红点提示;    马文涛 2013/02/05
//        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"banben"] == 1) {
//            [objMore.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabmore-selected-1.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabmore-1.png"]];
//        }
//        else{
//            [objMore.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabmore-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabmore.png"]];
//        }        
//    }
//    else
//    {
//        objMore.tabBarItem = [[[CustomTabBarItem alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"tabmore.png"] highlightedImage:[UIImage imageNamed:@"tabmore-selected.png"] tag:5] autorelease];
//    }
//    UINavigationController *navContrMoreController = [[UINavigationController alloc] initWithRootViewController:objMore];
//    [arrViewsArray addObject:navContrMoreController];
//    [navContrMoreController release];
//    [objMore release];
//    
//	UITabBarController *_tabBar= [[UITabBarController alloc] init];
//    CGRect frame;
//    if (IS_IPHONE_5) {
//        frame = CGRectMake(0, 435+86, 320, 51);
//    }
//    else
//    {
//        // 300 435
//        frame = CGRectMake(0, 435, 320, 51);
//    }
//        [_tabBar.tabBar setFrame:frame];
//	self.tabBarView=_tabBar;
//	self.tabBarView.viewControllers=arrViewsArray;
//    self.tabBarView.tabBar.opaque = YES;
//    
//	self.tabBarView.delegate=self;
//	[self.navigationController setNavigationBarHidden:YES];
//	
//	[arrViewsArray release];
//	[self.view addSubview:self.tabBarView.view];
//	[_tabBar release];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(viewController == [self.tabBarView.viewControllers objectAtIndex:0])
    {
        
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController *selectedViewController = tabBarController.selectedViewController;
    if ([selectedViewController isEqual:viewController])
    {
        return YES;
    }
    else
    {
        return YES;
    }
}

@end


