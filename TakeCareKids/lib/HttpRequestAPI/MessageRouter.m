//
//  MessageRouter.m
//  
//
//  Created by rexshi on 11/10/11.
//  Copyright (c) 2011 rexshi. All rights reserved.
//

#import "MessageRouter.h"

static MessageRouter * instance=nil;

@implementation MessageRouter

//+ (MessageRouter *)getInstance
//{
//    MessageRouter *client = [[[MessageRouter alloc] init] autorelease];
//    return client;
//}

+(MessageRouter*) getInstance
{
    @synchronized(self)
    {
        if (instance==nil) {
            instance=[[MessageRouter alloc] init];
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.client = [[[HttpRequestAPI alloc] init] autorelease];
        _client.delegate = self;
        _client.finishSelector = @selector(finish:errorInfo:);
        _client.finishErrorSelector = @selector(finishError:errorInfo:);
        [self.client start];
    }
    
    return self;
}

- (void)dealloc
{
    [_client release];
    [_userInfo release];
    [super dealloc];
}

#pragma mark -HttpRequestAPIDelegate

- (void) finish:(NSDictionary *)delegateInfo errorInfo:(NSDictionary *)result
{
    id object = [delegateInfo objectForKey:@"delegate"];
    NSString *selectorName = [delegateInfo objectForKey:@"selector"];
    
    NSArray *parts = [selectorName componentsSeparatedByString:@":"];
    int count = [parts count];
    if (count == 2) {
        if (object && [object respondsToSelector:NSSelectorFromString(selectorName)])
        {
            [object performSelector:NSSelectorFromString(selectorName)
                         withObject:result];
        }

    } else if (count == 3) {

        if (object && [object respondsToSelector:NSSelectorFromString(selectorName)])
        {
            [object performSelector:NSSelectorFromString(selectorName)
                         withObject:result
                         withObject:self];
        }
    } else {
        return;
    }
}

- (void) finishError:(NSDictionary *)delegateInfo errorInfo:(NSDictionary *)errorInfo
{    
    id object = [delegateInfo objectForKey:@"delegate"];
    NSString *errorSelectorName = [delegateInfo objectForKey:@"errorSelector"];
    
    NSArray *parts = [errorSelectorName componentsSeparatedByString:@":"];
    int count = [parts count];
    if (count == 2) {
        if (object && [object respondsToSelector:NSSelectorFromString(errorSelectorName)])
        {
            [object performSelector:NSSelectorFromString(errorSelectorName)
                         withObject:errorInfo];
        }

    } else if (count == 3) {
        if (object && [object respondsToSelector:NSSelectorFromString(errorSelectorName)])
        {
            [object performSelector:NSSelectorFromString(errorSelectorName)
                         withObject:errorInfo
                         withObject:self];
        }

    } else {
        return;
    }
}

#pragma mark - user

/**
 * Method name: 用户登录
 * Description: 
 * Parameters: email, password, token(push token, android直接传空字符串即可)
 */
- (void)userLoginWithUserName:(NSString *)username password:(NSString *)password
                  delegate:(id)delegate selector:(SEL)selector
             errorSelector:(SEL)errorSelector
{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"user",
                            [password md5Hash], @"pwd",
                            nil];
    
    [_client callMethodWithMod:@"login.php"
                        params:params
                    postParams:nil
                         files:nil
                       cookies:nil
                        header:nil
                      delegate:delegate
                      selector:selector
                 errorSelector:errorSelector];
}
- (void)getTerminalListWithUid:(NSString *)uid
                      password:(NSString *)password
                      delegate:(id)delegate
                      selector:(SEL)selector
                 errorSelector:(SEL)errorSelector
{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            uid, @"uid",
                            [password md5Hash], @"pwd",
                            nil];
    
    [_client callMethodWithMod:@"terminals.php"
                        params:params
                    postParams:nil
                         files:nil
                       cookies:nil
                        header:nil
                      delegate:delegate
                      selector:selector
                 errorSelector:errorSelector];
    
}

- (void)getLocListWithUid:(NSString *)uid
                 password:(NSString *)password
                  withTid:(NSString *)tid
                 delegate:(id)delegate
                 selector:(SEL)selector
            errorSelector:(SEL)errorSelector
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            uid, @"uid",
                            [password md5Hash], @"pwd",
                            tid, @"tid",
                            nil];
    
    [_client callMethodWithMod:@"pos_last.php"
                        params:params
                    postParams:nil
                         files:nil
                       cookies:nil
                        header:nil
                      delegate:delegate
                      selector:selector
                 errorSelector:errorSelector];
}

- (void)getLocHistoryWithUid:(NSString *)uid
                 password:(NSString *)password
                  withTid:(NSString *)tid
                      withBt:(NSString *)bt
                  withEt:(NSString *)et
                 delegate:(id)delegate
                 selector:(SEL)selector
            errorSelector:(SEL)errorSelector
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            uid, @"uid",
                            [password md5Hash], @"pwd",
                            [tid URLEncodedString], @"tid",
                            [bt URLEncodedString], @"bt",
                            [et URLEncodedString], @"et",
                            nil];
    
    [_client callMethodWithMod:@"pos_range.php"
                        params:params
                    postParams:nil
                         files:nil
                       cookies:nil
                        header:nil
                      delegate:delegate
                      selector:selector
                 errorSelector:errorSelector];
}
- (void)bindLoginWithSNS:(NSString *)email password:(NSString *)password
                  delegate:(id)delegate selector:(SEL)selector
             errorSelector:(SEL)errorSelector
{
    
//    {"bindNo":"2141088385","type":2,"token":"2.00dtmt1C0H7CVc2692d7addaa7dVAC","appver":"1.0","phoneType":1,"lang":"zh","device":"ewtr345346t456456456445","encoding":0}
//    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"2141088385", @"bindNo",
                            @"2", @"type",
                            @"2.00dtmt1C0H7CVc2692d7addaa7dVAC", @"token",
                            @"ewtr345346t456456456445", @"device",
                            @"zh", @"lang",
                            @"0", @"phoneType",
                            @"1.0", @"appver",
                            @"0", @"encoding", 
                            nil];
    
    [_client callMethodWithMod:@"user.bindLogin"
                        params:nil
                    postParams:params
                         files:nil
                       cookies:nil
                        header:nil
                      delegate:delegate
                      selector:selector
                 errorSelector:errorSelector];
}

@end
