//
//  HttpManager.m
//  test
//
//  Created by Jeffrey Ma on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "HttpManager.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation HttpManager
@synthesize requestQueue;
@synthesize delegate;
//@synthesize authCode;
//@synthesize authToken;
//@synthesize userId;

#pragma mark - Init

-(void)dealloc
{
//    self.userId = nil;
//    self.authToken = nil;
//    self.authCode = nil;
    self.requestQueue = nil;
    [super dealloc];
}

//初始化
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    if (self) {
        requestQueue = [[ASINetworkQueue alloc] init];
        [requestQueue setDelegate:self];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        [requestQueue setRequestWillRedirectSelector:@selector(request:willRedirectToURL:)];
		[requestQueue setShouldCancelAllRequestsOnFailure:NO];
        [requestQueue setShowAccurateProgress:YES];
        self.delegate = theDelegate;
    }
    return self;
}

#pragma mark - Methods
//- (void)setGetUserInfo:(ASIHTTPRequest *)request withRequestType:(RequestType)requestType {
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:[NSNumber numberWithInt:requestType] forKey:USER_INFO_KEY_TYPE];
//    [request setUserInfo:dict];
//    [dict release];
//}
//
//- (void)setPostUserInfo:(ASIFormDataRequest *)request withRequestType:(RequestType)requestType {
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:[NSNumber numberWithInt:requestType] forKey:USER_INFO_KEY_TYPE];
//    [request setUserInfo:dict];
//    [dict release];
//}
//
//- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
//	if (params) {
//		NSMutableArray* pairs = [NSMutableArray array];
//		for (NSString* key in params.keyEnumerator) {
//			NSString* value = [params objectForKey:key];
//			NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
//																						  NULL, /* allocator */
//																						  (CFStringRef)value,
//																						  NULL, /* charactersToLeaveUnescaped */
//																						  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//																						  kCFStringEncodingUTF8);
//
//            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
//			[escaped_value release];
//		}
//		
//		NSString* query = [pairs componentsJoinedByString:@"&"];
//		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
//		return [NSURL URLWithString:url];
//	} else {
//		return [NSURL URLWithString:baseURL];
//	}
//}
//
#pragma mark - Http Operate

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
//    //https://api.weibo.com/2/statuses/home_timeline.json
//    
//    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
//    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
//    
//    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:authToken,@"access_token",nil];
//    if (sinceID >= 0) {
//        NSString *tempString = [NSString stringWithFormat:@"%lld",sinceID];
//        [params setObject:tempString forKey:@"since_id"];
//    }
//    if (maxID >= 0) {
//        NSString *tempString = [NSString stringWithFormat:@"%lld",maxID];
//        [params setObject:tempString forKey:@"max_id"];
//    }
//    if (count >= 0) {
//        NSString *tempString = [NSString stringWithFormat:@"%d",count];
//        [params setObject:tempString forKey:@"count"];
//    }
//    if (page >= 0) {
//        NSString *tempString = [NSString stringWithFormat:@"%d",page];
//        [params setObject:tempString forKey:@"page"];
//    }
//    if (baseApp >= 0) {
//        NSString *tempString = [NSString stringWithFormat:@"%d",baseApp];
//        [params setObject:tempString forKey:@"baseApp"];
//    }
//    if (feature >= 0) {
//        NSString *tempString = [NSString stringWithFormat:@"%d",feature];
//        [params setObject:tempString forKey:@"feature"];
//    }
//    
    NSString *baseUrl =[NSString  stringWithFormat:@"%@", @"http://192.168.128.53/uploadtest/handler/handler10mins.ashx"];
    NSURL *url = [NSURL URLWithString:baseUrl];
    //NSURL *url = [self generateURL:baseUrl params:params];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    NSLog(@"url=%@",url);
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:GetHomeLine] forKey:USER_INFO_KEY_TYPE];
    if (maxID>0) {
        [dict setObject:@"YES" forKey:@"isRefresh"];
    }
    [request setUserInfo:dict];
    [dict release];
    [requestQueue addOperation:request];
    [request release];
}

#pragma mark - Operate queue
- (BOOL)isRunning
{
	return ![requestQueue isSuspended];
}

- (void)start
{
	if( [requestQueue isSuspended] )
		[requestQueue go];
}

- (void)pause
{
	[requestQueue setSuspended:YES];
}

- (void)resume
{
	[requestQueue setSuspended:NO];
}

- (void)cancel
{
	[requestQueue cancelAllOperations];
}

#pragma mark - ASINetworkQueueDelegate
//失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed:%@,%@,",request.responseString,[request.error localizedDescription]);
    
    NSNotification *notification = [NSNotification notificationWithName:MMSinaRequestFailed object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *userInformation = [request userInfo];
    RequestType requestType = [[userInformation objectForKey:USER_INFO_KEY_TYPE] intValue];
    NSString * responseString = [request responseString];
    NSLog(@"responseString = %@",responseString);
    
    //认证失败
    //{"error":"auth faild!","error_code":21301,"request":"/2/statuses/home_timeline.json"}
    SBJsonParser *parser = [[SBJsonParser alloc] init];    
    id  returnObject = [parser objectWithString:responseString];
    [parser release];
//    if ([returnObject isKindOfClass:[NSDictionary class]]) {
//        NSString *errorString = [returnObject  objectForKey:@"error"];
//        if (errorString != nil && ([errorString isEqualToString:@"auth faild!"] || 
//                                   [errorString isEqualToString:@"expired_token"] || 
//                                   [errorString isEqualToString:@"invalid_access_token"])) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NeedToReLogin object:nil];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
//            NSLog(@"detected auth faild!");
//        }
//    }
//    
    NSDictionary *userInfo = nil;
    NSArray *userArr = nil;
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        userInfo = (NSDictionary*)returnObject;
    }
    else if ([returnObject isKindOfClass:[NSArray class]]) {
        userArr = (NSArray*)returnObject;
    }
    else {
        return;
    }

    //获取当前登录用户及其所关注用户的最新微博
    if (requestType == GetHomeLine) {
//        NSArray *arr = [userInfo objectForKey:@"statuses"];
//        
//        if (arr == nil || [arr isEqual:[NSNull null]]) 
//        {
//            return;
//        }
        
        NSMutableArray  *statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (id item in userArr)
        {
            Group *groupOne = [Group groupWithJsonDictionary:item];
            [statuesArr addObject:groupOne];
        }
//        NSString *isRefresh = [userInformation objectForKey:@"isRefresh"];
//        if ([isRefresh isEqualToString:@"YES"]) {
//            Status* s = [statuesArr objectAtIndex:0];
//            s.isRefresh = @"YES";
//        }
        if ([delegate respondsToSelector:@selector(didGetHomeLine:)]) {
            [delegate didGetHomeLine:statuesArr];
        }
        [statuesArr release];
    }
}

//跳转
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
    NSLog(@"request will redirect");
}

@end
