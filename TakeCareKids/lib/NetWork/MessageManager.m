//
//  MessageManager.m
//  test
//
//  Created by Jeffrey Ma on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "MessageManager.h"

static MessageManager * instance=nil;

@implementation MessageManager
@synthesize httpManager;

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        httpManager = [[HttpManager alloc] initWithDelegate:self];
        [httpManager start];
    }
    return self;
}

+(MessageManager*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[MessageManager alloc] init];
        }
    }
    return instance;
}

#pragma mark - Http Methods
//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature
{
    [httpManager getHomeLine:sinceID maxID:maxID count:count page:page baseApp:baseApp feature:feature];
}

#pragma mark - HttpManagerDelegate
//获取当前登录用户及其所关注用户的最新微博
-(void)didGetHomeLine:(NSArray *)statusArr
{
    if (statusArr == nil || [statusArr count] == 0) {
        return;
    }
    NSNotification *notification = [NSNotification notificationWithName:MMGotHomeLine object:statusArr];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
