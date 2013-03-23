//
//  HttpManager.h
//  test
//
//  Created by Jeffrey Ma on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "StringUtil.h"
#import "NSStringAdditions.h"
#import <CoreLocation/CoreLocation.h>
#import "Group.h"

#define USER_INFO_KEY_TYPE          @"requestType"
#define USER_STORE_USER_NAME        @"SinaUserName"
#define USER_OBJECT                 @"USER_OBJECT"
#define NeedToReLogin               @"NeedToReLogin"

#define MMSinaRequestFailed         @"MMSinaRequestFailed"

typedef enum {
    GetOauthCode = 0,           //authorize_code
    GetHomeLine                //获取当前登录用户及其所关注用户的最新微博
} RequestType;

@class ASINetworkQueue;

//HttpManagerDelegate
@protocol HttpManagerDelegate <NSObject>

@optional
//获取当前登录用户及其所关注用户的最新微博
-(void)didGetHomeLine:(NSArray*)statusArr;

@end

@interface HttpManager : NSObject
{
    ASINetworkQueue *requestQueue;
    id<HttpManagerDelegate> delegate;
    
//    NSString *authCode;
//    NSString *authToken;
//    NSString *userId;
}

@property (nonatomic,retain) ASINetworkQueue *requestQueue;
@property (nonatomic,assign) id<HttpManagerDelegate> delegate;
//@property (nonatomic,copy) NSString *authCode;
//@property (nonatomic,copy) NSString *authToken;
//@property (nonatomic,copy) NSString *userId;

- (id)initWithDelegate:(id)theDelegate;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;


//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;

@end
