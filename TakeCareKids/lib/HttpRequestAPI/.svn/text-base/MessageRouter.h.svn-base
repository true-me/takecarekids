//
//  MessageRouter.h
//  
//
//  Created by Jeffrey on 2011/10/12.
//  Copyright (c) 2011 Jeffrey. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HttpRequestAPI.h"

//@protocol HttpRequestAPIDelegate;
//@class HttpRequestAPI;

@interface MessageRouter : NSObject <HttpRequestAPIDelegate>

@property (nonatomic, retain) HttpRequestAPI *client;
@property (nonatomic, retain) NSDictionary *userInfo;

+ (MessageRouter *)getInstance;

#pragma mark - user

- (void)userLoginWithEmail:(NSString *)email password:(NSString *)password
                   delegate:(id)delegate selector:(SEL)selector
              errorSelector:(SEL)errorSelector;

- (void)bindLoginWithSNS:(NSString *)email password:(NSString *)password
                  delegate:(id)delegate selector:(SEL)selector
             errorSelector:(SEL)errorSelector;

@end
