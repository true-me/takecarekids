//
//  CommonMethods.m
//  DuoTin
//
//  Created by Tom  on 10/31/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "GlobaMethods.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@implementation GlobaMethods

+(BOOL)isUserAuth
{
    NSString *uid =[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if (uid && [DataCheck isValidString:uid])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

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
    NSInteger c = 1;
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
