//
//  MemberDAL.h
//  DuoTin
//
//  Created by Tom  on 12/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
//#import "AlbumContentModel.h"

@class UserModel;

@interface MemberDAL : NSObject<ASIHTTPRequestDelegate>


@property(nonatomic,unsafe_unretained)id delegate;
@property(nonatomic, strong) ASIHTTPRequest *request;
@property(nonatomic, strong) ASIFormDataRequest *formRequest;

+(MemberDAL *)memberDAL;

-(void)GetUserInfoWithURL:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del;
-(void)GetUserContentFollowedWithURL:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del;

-(void)PostRegWithURL:(NSString*)urlString withTag:(NSInteger)tag withDelegate:(id)del email:(NSString*)email loginid:(NSString*)loginid pwd:(NSString*)pwd mac:(NSString *)macadress;
-(void)PostForgetEmailWithURL:(NSString*)urlString withTag:(NSInteger)tag withDelegate:(id)del email:(NSString*)email;
-(void)PostLoginWithURL:(NSString*)urlString withTag:(NSInteger)tag withDelegate:(id)del loginid:(NSString*)loginid pwd:(NSString*)pwd mac:(NSString *)macadress;
-(void)PostVersionWithURL:(NSString*)urlString withTag:(NSInteger)tag withDelegate:(id)del version:(NSString*)version;

-(void)GetConcernAlbums:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del;
-(void)CancelConcernAlbums:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del delarr:(NSMutableArray*)delarr;
-(void)CancelCollectContents:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del delarr:(NSMutableArray*)delarr;

-(void)GetMemberInfoWithURL:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del;

-(BOOL)UserExists;

+(void)SaveUser:(UserModel*)model;
+(void)DeleteUser;
+(void) DeleteUserListenData;
+(UserModel*)GetUserInfo;

-(NSMutableArray*)ReadListenHistory;
//-(void) saveListenHistory:(AlbumContentModel *) contentModel;

@end

@protocol MemberDALDelegate <NSObject>

-(void )ReturnDic:(NSMutableDictionary *)dic withTag:(NSInteger )tag;
-(void )ReturnFailed:(NSError *)error withTag:(NSInteger )tag;
@end
