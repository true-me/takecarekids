//
//  UserModel.h
//  DuoTin
//
//  Created by Tom  on 12/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic, retain) NSString *sID;
@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *realname;
@property(nonatomic, retain) NSString *sex;
@property(nonatomic, retain) NSString *qq;
@property(nonatomic, retain) NSString *mobile;
@property(nonatomic, retain) NSString *image_url;
@property(nonatomic, retain) NSString *pwd;
@property(nonatomic, retain) NSString *token;

@end
