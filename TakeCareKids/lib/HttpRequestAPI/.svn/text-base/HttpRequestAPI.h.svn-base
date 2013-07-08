//
//  HttpRequestAPI.h
//  
//
//  Created by Jeffrey on 11/10/11.
//  Copyright (c) 2011 Jeffrey. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "SRASIDownloadCache.h"

//@protocol HttpRequestAPIDelegate;
#pragma mark - HttpRequestAPIDelegate
@protocol HttpRequestAPIDelegate <NSObject>
- (void) finish:(NSArray *)delegateInfo errorInfo:(NSDictionary *)result;
- (void) finishError:(NSArray *)delegateInfo errorInfo:(NSDictionary *)errorInfo;
@end

@interface HttpRequestAPI : NSObject <ASIHTTPRequestDelegate> {

    ASIHTTPRequest *_request;
    ASINetworkQueue *_requestQueue;
    id<HttpRequestAPIDelegate> _delegate;
    SEL _finishSelector;
    SEL _finishErrorSelector;
    NSArray *_images;
    NSDictionary *_customUserInfo;
}

@property (nonatomic,retain) ASINetworkQueue *requestQueue;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, assign) id<HttpRequestAPIDelegate> delegate;
@property (nonatomic) SEL finishSelector;
@property (nonatomic) SEL finishErrorSelector;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSDictionary *customUserInfo;
@property (nonatomic) BOOL useCache;
@property (nonatomic) BOOL enableCache;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancelQueue;

- (NSString *)getRequestUrl:(NSString *)mod
                     params:(NSDictionary *)params;

- (void)cancel;

- (void)callMethodWithMod:(NSString *)mod
                   params:(NSDictionary *)params
               postParams:(NSDictionary *)postParams
                    files:(NSArray *)files
                  cookies:(NSDictionary *)cookies
                   header:(NSDictionary *)header
                 delegate:(id)delegate
                 selector:(SEL)selector
            errorSelector:(SEL)errorSelector;

@end

