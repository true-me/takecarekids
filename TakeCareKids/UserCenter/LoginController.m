//
//  LoginController.m
//  DuoTin
//
//  Created by Tom  on 12/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "LoginController.h"
//#import "RegistController.h"
#import "CommonMethods.h"
#import "UserModel.h"
//#import "ForgetPwdController.h"

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
    
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 220 / 11)];
//	[label setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:19]];
//    
//	label.textColor = [UIColor whiteColor];
//	label.backgroundColor = [UIColor clearColor];
//	label.textAlignment = UITextAlignmentCenter;
//	label.text = @"登陆注册";
//	self.navigationItem.titleView = label;
//	[label release];
    [self setUpTitleView:@"登陆注册"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:[UIImage imageNamed:@"titbar_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"titbar_back_on"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didTapBackButton1:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0.0f, 0.0f, 45.0f, 30.0f);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    [self.txtLoginID setDelegate:self];
    [self.txtLoginID setReturnKeyType:UIReturnKeyDone];
    [self.txtLoginID addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.txtPwd setDelegate:self];
    [self.txtPwd setSecureTextEntry:YES];
    [self.txtPwd setReturnKeyType:UIReturnKeyDone];
    [self.txtPwd addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(IBAction)didTapBackButton1:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
//    ForgetPwdController *obj = [[ForgetPwdController alloc] init];
//    [self.navigationController pushViewController:obj animated:YES];
//    [obj release];
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
	
    [HUD showAnimated:YES whileExecutingBlock:^{sleep(1.5f);} completionBlock:^{
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
        if([self.delegate respondsToSelector:@selector(LoginRecieved)])
        {
            [self.delegate LoginRecieved];
        }
        [self dismissModalViewControllerAnimated:YES];
    }];
    
//    NSString *u = [NSString stringWithFormat:@"%@%@", BASE_URL, OC("user/login")];
//    [[MemberDAL memberDAL] PostLoginWithURL:u withTag:TAG_USER_LOGIN withDelegate:self loginid:self.txtLoginID.text pwd:self.txtPwd.text mac:[CommonMethods macaddress]];
}

-(IBAction)btnRegClick:(id)sender
{
//    RegistController *obj = [[RegistController alloc] init];
//    [self.navigationController pushViewController:obj animated:YES];
//    [obj release];
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

-(void)ReturnDic:(NSMutableDictionary *)dic withTag:(NSInteger)tag
{
    [HUD hide:YES];
    if(tag == TAG_USER_LOGIN)
    {
        //BOOL regSucceed = [[dic objectForKey:@"success"] boolValue];
        BOOL regSucceed = YES;
        if(!regSucceed)
        {
            NSString *errorMsg = [dic objectForKey:@"error"];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            UserModel *userModel = [[UserModel alloc] init];
            userModel.username = self.txtLoginID.text;
            userModel.pwd = self.txtPwd.text;
            userModel.token = [dic objectForKey:@"token"];
            userModel.sID = OC("0");
            userModel.realname = OC("");
            userModel.sex = OC("");
            userModel.qq = OC("");
            userModel.mobile = OC("");
            userModel.image_url = OC("");
//            [MemberDAL SaveUser:userModel];
            RELEASE_SAFELY(userModel)
            
            if([self.delegate respondsToSelector:@selector(LoginRecieved)])
            {
                [self.delegate LoginRecieved];
            }
            [self dismissModalViewControllerAnimated:YES]; 
        }
    }
}

-(void )ReturnFailed:(NSError *)error withTag:(NSInteger )tag
{
    [HUD hide:YES];
    
    if(tag == 101)//Get Home Recommand List
    {
         if([CommonMethods checkNetworkStatus] == 0){
             UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
         }
    }
}

@end
