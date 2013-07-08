//
//  LoginController.m
//  DuoTin
//
//  Created by Tom  on 12/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
-(BOOL)CheckForm;
@end

@implementation LoginController

@synthesize delegate = _delegate;
@synthesize txtLoginID = _txtLoginID;
@synthesize txtPwd = _txtPwd;
@synthesize btnLogin = _btnLogin;
@synthesize btnReg = _btnReg;
@synthesize btnForgetPwd = _btnForgetPwd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    RELEASE_SAFELY(_txtLoginID);
    RELEASE_SAFELY(_txtPwd);
    RELEASE_SAFELY(_btnLogin);
    RELEASE_SAFELY(_btnReg);
    RELEASE_SAFELY(_btnForgetPwd);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupTitle:@"登陆系统"];

    [self.txtLoginID setDelegate:self];
    [self.txtLoginID setReturnKeyType:UIReturnKeyDone];
    [self.txtLoginID addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.txtPwd setDelegate:self];
    [self.txtPwd setSecureTextEntry:YES];
    [self.txtPwd setReturnKeyType:UIReturnKeyDone];
    [self.txtPwd addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake(9, 175, 302, 44);
    UIImage * image = [UIImage imageNamed:@"btn_login_normal.png"];
    UIImage * imageH = [UIImage imageNamed:@"btn_login_pressed.png"];
    exitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [exitButton setTitle:NSLocalizedString(@"登录", @"登录") forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitButton setTitleShadowColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    exitButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [exitButton setBackgroundImage:[image stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    [exitButton setBackgroundImage:[imageH stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateHighlighted];
    [exitButton addTarget:self action:@selector(btnLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
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

#pragma mark CheckForm

-(BOOL)CheckForm
{
    NSString *trimmedString = [self.txtLoginID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([trimmedString isEqualToString:@""])
    {
        [[[[UIAlertView alloc] initWithTitle:@"提示"
                                     message:[NSString stringWithFormat:@"用户名不能为空"]
                                    delegate:nil
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil] autorelease] show];
        return NO;
    }
    
    trimmedString = [self.txtPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([trimmedString isEqualToString:@""])
    {
        [[[[UIAlertView alloc] initWithTitle:@"提示"
                                     message:[NSString stringWithFormat:@"密码不能为空"]
                                    delegate:nil
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil] autorelease] show];
        return NO;
    }
    
    return YES;
}

#pragma mark IBAction

-(IBAction)btnForgetPwd:(id)sender
{

}

-(IBAction)btnLoginClick:(id)sender
{
    [self.view endEditing:YES];
    
    if(![self CheckForm])
    {
        return;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"提交数据";
	
    [HUD showAnimated:YES whileExecutingBlock:^{sleep(0.8f);} completionBlock:^{
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
        if([self.delegate respondsToSelector:@selector(LoginRecieved)])
        {
            [self.delegate LoginRecieved];
        }
        [self dismissModalViewControllerAnimated:YES];
    }];
    

}

-(IBAction)btnRegClick:(id)sender
{

}

#pragma mark TextField Methods

-(IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark Recive data

@end
