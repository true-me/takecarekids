//
//  CommonMethods.m
//  DuoTin
//
//  Created by Tom  on 10/31/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "CommonMethods.h"
#import "SQLite.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@implementation CommonMethods

+(NSString *)getFileSizeString:(NSString *)size
{
    if([size floatValue]>=1024*1024)
    {
        return [NSString stringWithFormat:@"%.2f MB",[size floatValue]/1024/1024];
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024)
    {
        return [NSString stringWithFormat:@"%.2f K",[size floatValue]/1024];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f B",[size floatValue]];
    }
}

+(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM = [size rangeOfString:@"M"].location;
    NSInteger indexK = [size rangeOfString:@"K"].location;
    NSInteger indexB = [size rangeOfString:@"B"].location;
    if(indexM<1000)
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else
    {
        return [size floatValue];
    }
}

+ (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name= nil;
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent += networkStatisc->ifi_obytes;
                    WiFiReceived += networkStatisc->ifi_ibytes;
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent += networkStatisc->ifi_obytes;
                    WWANReceived += networkStatisc->ifi_ibytes;
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    NSString *mWifiSent = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:WiFiSent]];
    NSString *mWifiReceived = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:WiFiReceived]];
    NSString *mWwanSent = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:WWANSent]];
    NSString *mWwanReceived = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:WWANReceived]];
    
    NSLog(@"%@", mWifiSent);
    NSLog(@"%@", mWifiReceived);
    NSLog(@"%@", mWwanSent);
    NSLog(@"%@", mWwanReceived);
    
    return [NSArray arrayWithObjects:mWifiSent, mWifiReceived, mWwanSent, mWwanReceived, nil];
}

+(void)SaveSatistics:(NSArray*)arrStart arrEnd:(NSArray*)arrEnd
{
    NSDate *today = [NSDate date];
    NSDate *lastMonth = [today dateByAddingTimeInterval: -5259487.66];
    
    SQLite *objsqld = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    NSString *strd = [NSString stringWithFormat:@"delete from trafficStatistics where strftime('%%m', logtime) = '%@'", [CommonMethods getMonthString:lastMonth]];
    [objsqld openDb];
    [objsqld updateDb:strd];
    [objsqld closeDb];
    [objsqld release];
    
    float startWifiSent = [[arrStart objectAtIndex:0] floatValue];
    float startWifiReceived = [[arrStart objectAtIndex:1] floatValue];
    float startWwanSent = [[arrStart objectAtIndex:2] floatValue];
    float startWwanReceived = [[arrStart objectAtIndex:3] floatValue];
    
    float endWifiSent = [[arrEnd objectAtIndex:0] floatValue];
    float endWifiReceived = [[arrEnd objectAtIndex:1] floatValue];
    float endWwanSent = [[arrEnd objectAtIndex:2] floatValue];
    float endWwanReceived = [[arrEnd objectAtIndex:3] floatValue];
    
    float wifitraffic = (endWifiReceived+endWifiSent)-(startWifiReceived+startWifiSent);
    float wwantraffic = (endWwanReceived+endWwanSent)-(startWwanReceived+startWwanSent);
    
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    [sqlobj openDb];
    
    NSString *str = [NSString stringWithFormat:@"insert into trafficStatistics(wifitraffic,wwantraffic,logtime) values (%f,%f,'%@')", wifitraffic, wwantraffic,[self stringhhmmssFromDate:[NSDate date]]];
    [sqlobj insertDb:str];
    
    [sqlobj closeDb];
    [sqlobj release];
}

+(NSArray*)getMonthStatistics
{
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    [sqlobj openDb];
	
	NSString *query=[NSString stringWithFormat:@"select sum(wifitraffic) as wifi,sum(wwantraffic) as wwan from trafficStatistics where strftime('%%m', logtime) = '%@'", [self getMonthString:[NSDate date]]];
	[sqlobj readDb:query];
    NSString *WifiStatistics = nil;
    NSString *WwanStatistics = nil;
	while ([sqlobj hasNextRow])
	{
        WifiStatistics = [sqlobj getColumn:0 type:@"text"];
        WwanStatistics = [sqlobj getColumn:1 type:@"text"];
	}
    
	[sqlobj closeDb];
	[sqlobj release];

    NSArray *arr = [NSArray arrayWithObjects:WifiStatistics, WwanStatistics, nil];
    return arr;
}
+(NSArray*)getTodayStatistics
{
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    [sqlobj openDb];
	
	NSString *query=[NSString stringWithFormat:@"select sum(wifitraffic) as wifi,sum(wwantraffic) as wwan from trafficStatistics where strftime('%%d', logtime) = '%@'", [self getDayString:[NSDate date]]];
	[sqlobj readDb:query];
    NSString *WifiStatistics = nil;
    NSString *WwanStatistics = nil;
	while ([sqlobj hasNextRow])
	{
        WifiStatistics = [sqlobj getColumn:0 type:@"text"];
        WwanStatistics = [sqlobj getColumn:1 type:@"text"];
	}
    
	[sqlobj closeDb];
	[sqlobj release];
    NSArray *arr = nil;
    arr = [NSArray arrayWithObjects:WifiStatistics,WwanStatistics, nil];

    return arr;
}

+(NSInteger)GetDownloadingCount
{
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    [sqlobj openDb];
	
	NSString *query=[NSString stringWithFormat:@"select count(id) as count from tableDownload where status='no'"];
	[sqlobj readDb:query];
    NSInteger Count = 0;
	while ([sqlobj hasNextRow])
	{
        Count = [[sqlobj getColumn:0 type:@"text"] intValue];
	}
	[sqlobj closeDb];
	[sqlobj release];
    return Count;
}

+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+(NSString *)getTargetFloderPath
{
    return [self getDocumentPath];
}

+ (unsigned long long int)getFolderSize:(NSString *)folderPath
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject])
    {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

+ (void)removeFolderContent:(NSString *)folderPath
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    while (fileName = [filesEnumerator nextObject])
    {
        [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error: nil];
    }    
}

+(void)removeDownloadedFile:(NSString*)fileName
{
    NSLog(@"%@", [self getTargetFloderPath]);
    NSLog(@"%@", fileName);
    [[NSFileManager defaultManager] removeItemAtPath:[[self getTargetFloderPath] stringByAppendingPathComponent:fileName] error: nil];
}

+(NSString *)getTempFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Temp"];
}

+(BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+(float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    return currentSize/totalSize;
}

+(void)SetBadgeNum:(NSArray*)tabbarItems
{
    NSInteger c = [self GetDownloadingCount];
    [UIApplication sharedApplication].applicationIconBadgeNumber = c;
    if(c <= 0)
    {
        [[tabbarItems objectAtIndex:2] setBadgeValue:nil];
    }
    else
    {
        [[tabbarItems objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]];
    }
}

+(NSInteger)GetBadgeNum
{
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

+(void)AddNumForBadge:(NSArray*)tabbarItems num:(NSInteger)num
{
    NSInteger c = [UIApplication sharedApplication].applicationIconBadgeNumber + num;
    [UIApplication sharedApplication].applicationIconBadgeNumber = c;
    [[tabbarItems objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]];
}

+(void)MinusNumForBadge:(NSArray*)tabbarItems num:(NSInteger)num
{
    NSInteger c = [UIApplication sharedApplication].applicationIconBadgeNumber - num;
    [UIApplication sharedApplication].applicationIconBadgeNumber = c;
    [[tabbarItems objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]];
}

+(void)MinusNumForBadge:(NSInteger)num
{
    NSInteger c = [UIApplication sharedApplication].applicationIconBadgeNumber - num;
    [UIApplication sharedApplication].applicationIconBadgeNumber = c;
}

+(void)SetBadgeNum:(NSArray*)tabbarItems count:(NSInteger)count
{
    NSInteger c = count;
    [UIApplication sharedApplication].applicationIconBadgeNumber = c;
    if(c <= 0)
    {
        [[tabbarItems objectAtIndex:2] setBadgeValue:nil];
    }
    else
    {
        [[tabbarItems objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber]];
    }
}

+(NSString*)getMonthString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return monthString;
}

+(NSString*)getDayString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dayString;
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return destDateString;
}

+ (NSString *)stringhhmmssFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return destDateString;
}

+(UITableViewCell *)addSeperator:(UITableViewCell *) cell{
    
    UIImageView *sepratorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split_line.png"]];
    
    CGRect frame = cell.frame;
    
    sepratorView.frame = CGRectMake(0, frame.size.height - 1.1, frame.size.width, 1.1);
    
    [cell.contentView addSubview:sepratorView];
    [sepratorView release];
        
    return cell;
}

+(void)createFolder:(NSString*)folderName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
}

// 保存正在播放的列表和进度
+(void)SaveLastPlayModel:(NSArray*)arrContentModel PlayingIndex:(NSInteger)playingIndex Progress:(double)progress
{
////    NSDate *today = [NSDate date];
////    NSDate *lastMonth = [today dateByAddingTimeInterval: -5259487.66];
////    
//    SQLite *objsqld = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
//    NSString *sql = [NSString stringWithFormat:@"delete from [tblLastPlayModels]"];
//    [objsqld openDb];
//    [objsqld updateDb:sql];
//    [objsqld closeDb];
//
//    for (NSInteger i=0; i < arrContentModel.count; i++)
//    {
//        NSString *selected = nil;
//        NSString *strProgress = nil;
//        if (playingIndex == i)
//        {
//            selected = [NSString stringWithFormat:@"YES"];
//            strProgress = [NSString stringWithFormat:@"%f", progress];
//        }
//        else
//        {
//            selected = [NSString stringWithFormat:@"NO"];
//            strProgress = [NSString stringWithFormat:@"%f", 0.0f];
//        }
//        
//        AlbumContentModel *acm = [arrContentModel objectAtIndex:i];
//        NSString *sqlSentence = [NSString stringWithFormat:@"insert into tblLastPlayModels(id,title,runtime,size,newstatus,listen_url,download_url,playtimes,image_url,album_id,collect_url,collected,file_size_16,file_size_32,file_url,seconds,album_image_url,album_title,upload_by,fileName, selected, progress, seq) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d','%d','%d','%@','%d','%@','%@','%@','%@','%@', '%@',%d)",
//                                 acm.sID,
//                                 acm.title,
//                                 acm.runtime,
//                                 acm.size,
//                                 acm.newstatus,
//                                 acm.listen_url,
//                                 acm.download_url,
//                                 acm.playtimes,
//                                 acm.image_url,
//                                 acm.album_id,
//                                 acm.collect_url,
//                                 acm.collected,
//                                 acm.file_size_16,
//                                 acm.file_size_32,
//                                 acm.file_url,
//                                 acm.seconds,
//                                 acm.album_image_url,
//                                 acm.album_title,
//                                 acm.upload_by,
//                                 @"",
//                                 selected,
//                                 strProgress,
//                                 i];
//
//        [objsqld openDb];
//        [objsqld insertDb:sqlSentence];
//        [objsqld closeDb];
//    }
//    [objsqld release];
}

+(NSMutableArray *) getLastArrayContentModel
{
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    [sqlobj openDb];
	
	NSString *query=[NSString stringWithFormat:@"select id,title,runtime,size,newstatus,listen_url,download_url,playtimes,image_url,album_id,collect_url,collected,file_size_16,file_size_32,file_url,seconds,album_image_url,album_title,upload_by,fileName, selected, progress from [tblLastPlayModels] ORDER BY seq asc"];
	[sqlobj readDb:query];
    
    NSMutableArray *arrContentModel = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
//	while ([sqlobj hasNextRow])
//	{
//        AlbumContentModel *acm =[[AlbumContentModel alloc] init];
//        acm.sID=                    [sqlobj getColumn: 0 type:@"text"] ;
//        acm.title=                  [sqlobj getColumn: 1 type:@"text"] ;
//        acm.runtime=                [sqlobj getColumn: 2 type:@"text"] ;
//        acm.size=                   [sqlobj getColumn: 3 type:@"text"] ;
//        acm.newstatus=              [sqlobj getColumn: 4 type:@"text"] ;
//        acm.listen_url=             [sqlobj getColumn: 5 type:@"text"] ;
//        acm.download_url=           [sqlobj getColumn: 6 type:@"text"] ;
//        acm.playtimes=              [sqlobj getColumn: 7 type:@"text"] ;
//        acm.image_url=              [sqlobj getColumn: 8 type:@"text"] ;
//        acm.album_id=               [sqlobj getColumn: 9 type:@"text"] ;
//        acm.collect_url=            [sqlobj getColumn:10 type:@"text"] ;
//        acm.collected=              [[sqlobj getColumn:11 type:@"text"] intValue];
//        acm.file_size_16=           [[sqlobj getColumn:12 type:@"text"] intValue];
//        acm.file_size_32=           [[sqlobj getColumn:13 type:@"text"] intValue];
//        acm.file_url=               [sqlobj getColumn:14 type:@"text"] ;
//        acm.seconds=                [[sqlobj getColumn:15 type:@"text"] intValue];
//        acm.album_image_url=        [sqlobj getColumn:16 type:@"text"] ;
//        acm.album_title=            [sqlobj getColumn:17 type:@"text"] ;
//        acm.upload_by =             [sqlobj getColumn:18 type:@"text"] ;
//        [arrContentModel addObject:acm];
//        [acm release];
//	}
//    
	[sqlobj closeDb];
	[sqlobj release];
    
    return arrContentModel;
}

+(NSInteger) getLastContentModelIndex
{
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    [sqlobj openDb];
	
	NSString *query=[NSString stringWithFormat:@"select [seq] from [tblLastPlayModels] where selected ='YES'"];
	[sqlobj readDb:query];
    
    NSInteger lastIndex = -1;
	while ([sqlobj hasNextRow])
	{
        lastIndex = [[sqlobj getColumn: 0 type:@"text"] intValue];
        break;
	}
    
	[sqlobj closeDb];
	[sqlobj release];
    
    return lastIndex;
}

+(double) getLastProgress
{
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    [sqlobj openDb];
	
	NSString *query=[NSString stringWithFormat:@"select progress from [tblLastPlayModels] where selected ='YES'"];
	[sqlobj readDb:query];
    
    double lastProgress = -1;
	while ([sqlobj hasNextRow])
	{
        lastProgress = [[sqlobj getColumn: 0 type:@"text"] doubleValue];
        break;
    }
    
	[sqlobj closeDb];
	[sqlobj release];
    
    return lastProgress;
}

+(NSString *) macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

#pragma mark
#pragma mark 检查当前网络是属于哪一种
+(NSInteger)checkNetworkStatus
{
    Reachability *currentReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([currentReach currentReachabilityStatus])
    {
        case NotReachable:
        {
            NSLog(@"网络中断");
            return -1;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"正在使用3G网络");
            return 0;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"正在使用wifi网络");
            return 1;
            break;
        }
        default:
        {
            NSLog(@"未知情况");
            return 2;
            break;
        }
    }
}


@end
