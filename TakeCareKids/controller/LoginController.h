//
//  LoginController.h
//  DuoTin
//
//  Created by Tom  on 12/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD.h"


@protocol loginDelegate <NSObject>
@optional
    -(void)LoginRecieved;
    -(void)LoginCompleted;
@end

@interface LoginController : BaseViewController<UITextFieldDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property(nonatomic, assign) id<loginDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIButton *btnLogin;
@property(nonatomic, retain) IBOutlet UIButton *btnReg;
@property(nonatomic, retain) IBOutlet UITextField *txtLoginID;
@property(nonatomic, retain) IBOutlet UITextField *txtPwd;
@property(nonatomic, retain) IBOutlet UIButton *btnForgetPwd;
@property(nonatomic, retain) MessageRouter *msgRouter;
@end
