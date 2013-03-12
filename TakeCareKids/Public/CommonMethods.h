//
//  CommonMethods.h
//  DuoTin
//
//  Created by Tom  on 10/31/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AlbumContentModel.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Reachability.h"
// get mac address required '.h' files
#include <sys/socket.h> // majunfei
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface CommonMethods : NSObject

#define T_MAC_ADDRESS @"MacAddress"
// 极光调用使用，暂时未启用
#define T_DEVICE_TOKEN @"deviceToken"
// umeng 的SDK
#define UMENG_SDK @"50f6a82a52701568e3000020"

#define ABOUTUS_SINAWEIBO @"http://weibo.com/u/2955982490"

#define APPLE_ID 594109494

#define APPDELEGETE (AppDelegate *)[[UIApplication sharedApplication]delegate]

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define BASE_URL @"http://www.duotin.com/api/"

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)  

/*--------------------Iphone5 的判断------------------------------------------------------*/
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON)

#define OC(str) [NSString stringWithCString:(str) encoding:NSUTF8StringEncoding]

#define TEXT_COLOR	 [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]
#define TITLE_COLOR	 [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]
#define GRAY_COLOR	 [UIColor colorWithRed:181.0/255.0 green:167.0/255.0 blue:154.0/255.0 alpha:1.0]

+(NSString *)getFileSizeString:(NSString *)size;

+(float)getFileSizeNumber:(NSString *)size;

+(NSString *)getTargetFloderPath;
+(NSString *)getTempFolderPath;
+(BOOL)isExistFile:(NSString *)fileName;

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (unsigned long long int)getFolderSize:(NSString *)folderPath;
+ (void)removeFolderContent:(NSString *)folderPath;

+(void)SetBadgeNum:(NSArray*)tabbarItems;
+(void)SetBadgeNum:(NSArray*)tabbarItems count:(NSInteger)count;

+(CGFloat) getProgress:(float)totalSize currentSize:(float)currentSize;
+(NSInteger)GetDownloadingCount;
+(void)AddNumForBadge:(NSArray*)tabbarItems num:(NSInteger)num;
+(void)MinusNumForBadge:(NSArray*)tabbarItems num:(NSInteger)num;
+(void)MinusNumForBadge:(NSInteger)num;

+(void)removeDownloadedFile:(NSString*)fileName;
+(UITableViewCell *)addSeperator:(UITableViewCell *) cell;
+ (NSArray *)getDataCounters;
+(void)SaveSatistics:(NSArray*)arrStart arrEnd:(NSArray*)arrEnd;
+(NSString*)getMonthString:(NSDate*)date;
+(NSString*)getDayString:(NSDate*)date;
+(NSArray*)getMonthStatistics;
+(NSArray*)getTodayStatistics;
+(void)createFolder:(NSString*)folderName;
+ (NSString *)stringhhmmssFromDate:(NSDate *)date;

+(NSInteger)GetBadgeNum;

+(void)SaveLastPlayModel:(NSArray*)arrContentModel PlayingIndex:(NSInteger)playingIndex Progress:(double)progress;
+(double) getLastProgress;
+(NSInteger) getLastContentModelIndex;
+(NSMutableArray *)getLastArrayContentModel;
+(NSString *) macaddress;
+(NSInteger)checkNetworkStatus;

#define ALBUM_CONTETN 304
#define ALBUM_PAGING 191
#define ALBUM_GET_ALL_CONTENT 192
#define ALBUM_SEARCH 305
#define ALBUM_FOLLOW 306
#define ALBUM_UNFOLLOW 406
#define CONTENT_SEARCH 307
#define GET_USER_INFO 308
#define GET_CONTENT_FOLLOWED 309
#define TAG_APP_VERSION 104
#define TAG_USER_FORGET 103
#define TAG_USER_REG 101
#define TAG_USER_LOGIN 102
#define TAG_USER_CONCERN 121
#define TAG_USER_CANCELCONCERN 122
#define TAG_USER_MAIN 100

typedef enum
{
    _Handled,
    _NotHandled
}IfHandled;

@end
