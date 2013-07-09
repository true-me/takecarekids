//
//  CommonMethods.h
//  DuoTin
//
//  Created by Tom  on 10/31/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Reachability.h"
#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface GlobaMethods : NSObject

+(NSString *)getFileSizeString:(NSString *)size;
+(float)getFileSizeNumber:(NSString *)size;
+(NSString *)getTargetFloderPath;
+(NSString *)getTempFolderPath;
+(BOOL)isExistFile:(NSString *)fileName;
+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)stringFromDate:(NSDate *)date;
+(unsigned long long int)getFolderSize:(NSString *)folderPath;
+(void)removeFolderContent:(NSString *)folderPath;

+(void)SetBadgeNum:(NSArray*)tabbarItems;
+(void)SetBadgeNum:(NSArray*)tabbarItems count:(NSInteger)count;
+(void)AddNumForBadge:(NSArray*)tabbarItems num:(NSInteger)num;
+(void)MinusNumForBadge:(NSArray*)tabbarItems num:(NSInteger)num;
+(void)MinusNumForBadge:(NSInteger)num;

+(CGFloat) getProgress:(float)totalSize currentSize:(float)currentSize;
+(UITableViewCell *)addSeperator:(UITableViewCell *) cell;
+(NSArray *)getDataCounters;
+(NSString*)getMonthString:(NSDate*)date;
+(NSString*)getDayString:(NSDate*)date;
+(void)createFolder:(NSString*)folderName;
+(NSString *)stringhhmmssFromDate:(NSDate *)date;
+(NSInteger)GetBadgeNum;
+(NSString *) macaddress;
+(NSInteger)checkNetworkStatus;
+(BOOL)isUserAuth;


@end
