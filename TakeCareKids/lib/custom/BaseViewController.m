//
//  BaseViewController.m
//  DuoTin
//
//  Created by Jeffrey Ma  on 11/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()
@end

@implementation BaseViewController

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
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    self.view.backgroundColor = [UIColor colorWithRed:223/255.0f green:225/255.0f blue:225/255.0f alpha:1];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
}

- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
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

-(void)setupTitleImageView:(NSString *)imageName
{
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    titleImageView.frame = CGRectMake(134, 9, 52, 22);
    self.navigationItem.titleView = titleImageView;
    [titleImageView release];
}

- (void) setupTitleView:(NSString*) title
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(80, 9, 160, 22)];
    [label setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.0f]];
    [label setMinimumFontSize:20.0f];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.shadowColor = [UIColor colorWithRed:0.0f
                                        green:0.0f
                                         blue:0.0f
                                        alpha:0.4f];
    label.shadowOffset = CGSizeMake(0.0f, 0.9f);
    label.text = title;
//    label.layer.borderColor = [[UIColor greenColor] CGColor];
//    label.layer.borderWidth = 2.0f;
    self.navigationItem.titleView = label;
    [label release];
}

- (void) setupSecondTitleView:(NSString*) title
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(80, 9, 160, 22)];
    [label setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f]];
    [label setMinimumFontSize:16.0f];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.shadowColor = [UIColor colorWithRed:0.0f
                                        green:0.0f
                                         blue:0.0f
                                        alpha:0.4f];
    label.shadowOffset = CGSizeMake(0.0f, 0.9f);
    label.text = title;
    //    label.layer.borderColor = [[UIColor greenColor] CGColor];
    //    label.layer.borderWidth = 2.0f;
    self.navigationItem.titleView = label;
    [label release];

}

-(void)setupLeftButton:(UIButton *)btn
{
    UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = sendButtonItem;
    [sendButtonItem release];
}

-(void)setupRightButton:(UIButton *)btn
{
    UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = sendButtonItem;
    [sendButtonItem release];
}

- (void )setupTitle:(NSString *)title
{
    CustomNavBarVC *navc= (CustomNavBarVC *)self.navigationController;
    [navc setupTitle:title];
}

- (void )setupTitle:(NSString *)title action:(SEL)selector target:(id)target
{
    CustomNavBarVC *navc= (CustomNavBarVC *)self.navigationController;
    [navc setupTitle:title action:selector target:target];
}


- (void )rightButtonWithTitle:(NSString *)title action:(SEL) selector onTarget:(id) target
{
    CustomNavBarVC *navc= (CustomNavBarVC *)self.navigationController;
    [navc rightButtonWithTitle:title action:selector onTarget:target];
}

- (void )leftButtonWithImage:(UIImage *)image action:(SEL) selector onTarget:(id) target
{
    CustomNavBarVC *navc= (CustomNavBarVC *)self.navigationController;
    [navc leftButtonWithImage:image action:selector onTarget:target];
}

- (void )rightButtonWithImage:(UIImage *)image action:(SEL) selector onTarget:(id) target
{
    CustomNavBarVC *navc= (CustomNavBarVC *)self.navigationController;
    [navc rightButtonWithImage:image action:selector onTarget:target];
}
- (void )leftButtonWithTitle:(NSString *)title action:(SEL) selector onTarget:(id) target
{
    CustomNavBarVC *navc= (CustomNavBarVC *)self.navigationController;
    [navc leftButtonWithTitle:title action:selector onTarget:target];
}


- (void) viewDidLayoutSubviews
{

    if ( IOS7_OR_LATER )
    {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
    [super viewWillLayoutSubviews];
    CustomNavBarVC *navc = (CustomNavBarVC *)self.navigationController;
    [navc.terminalMenu setNeedsLayout];

}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

-(void) showHUD:(NSString *) text afterDelay:(CGFloat) delay
{
    [self showHUD:text];
    [self hideHUD:delay];
}

-(void) showHUD:(NSString *) text
{
    CustomNavBarVC *navc = (CustomNavBarVC *) self.navigationController;
    if (navc)
    {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:navc.view];
        if (!hud)
        {
            hud = [MBProgressHUD showHUDAddedTo:navc.view animated:YES];
            //        hud.mode = MBProgressHUDModeText;
            
            hud.opaque = YES;
            hud.dimBackground = YES;
            hud.square = YES;
            hud.removeFromSuperViewOnHide = YES;
        }
        
        hud.labelText = text;
        //        [hud show:YES];
    }
}

-(void) hideHUD
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    if (hud)
    {
        [hud hide:YES];
    }
}

-(void) hideHUD:(CGFloat) delay
{
    //    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    if (hud)
    {
        [hud hide:YES afterDelay:delay];
    }
}

@end
