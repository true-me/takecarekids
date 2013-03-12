//
//  UserModel.m
//  DuoTin
//
//  Created by Tom  on 12/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "UserModel.h"
#import "CommonMethods.h"

@implementation UserModel

@synthesize sID = _sID;
@synthesize username = _username;
@synthesize realname = _realname;
@synthesize sex = _sex;
@synthesize qq = _qq;
@synthesize mobile = _mobile;
@synthesize image_url = _image_url;
@synthesize pwd = _pwd;
@synthesize token = _token;

-(void)dealloc
{
    RELEASE_SAFELY(_sID);
    RELEASE_SAFELY(_username);
    RELEASE_SAFELY(_realname);
    RELEASE_SAFELY(_sex);
    RELEASE_SAFELY(_qq);
    RELEASE_SAFELY(_mobile);
    RELEASE_SAFELY(_image_url);
    RELEASE_SAFELY(_pwd);
    RELEASE_SAFELY(_token);
    [super dealloc];
}

@end
