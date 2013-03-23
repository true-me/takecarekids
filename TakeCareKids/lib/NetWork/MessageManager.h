//
//  MessageManager.h
//  
//
//  Created by Jeffrey Ma on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

//获取当前登录用户及其所关注用户的最新微博
//返回成员为Status的NSArray
#define MMGotHomeLine @"MMGotHomeLine"


@interface MessageManager : NSObject <HttpManagerDelegate>
{
    HttpManager *httpManager;
}
@property (nonatomic,retain)HttpManager *httpManager;

+(MessageManager*)getInstance;

//获取当前登录用户及其所关注用户的最新微博
-(void)getHomeLine:(int64_t)sinceID maxID:(int64_t)maxID count:(int)count page:(int)page baseApp:(int)baseApp feature:(int)feature;
@end
