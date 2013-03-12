//
//  BaseViewController.m
//  DuoTin
//
//  Created by Tom  on 11/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "BaseViewController.h"
//#import "DTPlayer.h"


@interface BaseViewController ()
-(void)customizeNowPlayingButton;
-(void)customizeBackButton;
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    // Do any additional setup after loading the view from its nib.
    
    [self customizeBackButton];
    [self customizeNowPlayingButton];
}

-(void)customizeBackButton
{
    if(self.navigationController.viewControllers.count > 1) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setImage:[UIImage imageNamed:@"titbar_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"titbar_back_on"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0.0f, 0.0f, 45.0f, 30.0f);
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = backButtonItem;
        [backButtonItem release];
    }
}

-(void)customizeNowPlayingButton
{
    if(self.navigationController.viewControllers.count >= 1) {
        
        
        UIImage* image = [UIImage imageNamed:@"titbar_con"];
        CGRect frame = CGRectMake(0, -0, 68.0f, 30.0f);
        UIButton *sendButton = [[UIButton alloc] initWithFrame:frame];
//        sendButton.layer.borderWidth = 1.0f;
//        sendButton.layer.borderColor = [[UIColor redColor] CGColor];
        
        UILabel * sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 68.0f, 30.0f)];
        [sendLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]];
        sendLabel.textColor = [UIColor whiteColor];
        sendLabel.shadowColor = [UIColor colorWithRed:0.0f
                                            green:0.0f
                                             blue:0.0f
                                            alpha:0.4f];
        sendLabel.shadowOffset = CGSizeMake(0.0f, 0.9f);
        sendLabel.backgroundColor = [UIColor clearColor];
        sendLabel.textAlignment = UITextAlignmentCenter;
        sendLabel.text = @"正在播放";
        [sendButton addSubview:sendLabel];
        [sendLabel release];
        
        [sendButton setImage:image forState:UIControlStateNormal];
        [sendButton setImage:[UIImage imageNamed:@"titbar_con_on"] forState:UIControlStateHighlighted];
        sendButton.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [sendButton addTarget:self action:@selector(clickNowPlayingButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *sendButtonItem=[[UIBarButtonItem alloc] initWithCustomView:sendButton];
        
        self.navigationItem.rightBarButtonItem = sendButtonItem;
        
        CGRect vframe = self.navigationItem.rightBarButtonItem.customView.frame;
        vframe.origin.y = 4.0f;
        self.navigationItem.rightBarButtonItem.customView.frame = vframe;

        [sendButton release];
        [sendButtonItem release];
    }
}

- (void) clickNowPlayingButton:(id)sender {
    
//    UINavigationController *navController = self.navigationController;    
////    DTPlayer *player = [[DTPlayer alloc] initWithModel:modelOne];
//    DTPlayer *player = [[DTPlayer alloc] init];    
//    //DTPlayer *player = [DTPlayer sharedSingleton];
//    //player.model = modelOne;
//    player.hidesBottomBarWhenPushed = YES;
//    [navController pushViewController:player animated:YES];
//    [player release];
////    if(self.navigationController.viewControllers.count > 1) {
//        NSLog(@"Should push image view to now playing.");
////    }
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

-(void)setUpTitleImageView:(NSString *)imageName
{
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    titleImageView.frame = CGRectMake(134, 9, 52, 22);
    self.navigationItem.titleView = titleImageView;
    [titleImageView release];
}

- (void) setUpTitleView:(NSString*) title
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

- (void) setUpSecondTitleView:(NSString*) title
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
@end
