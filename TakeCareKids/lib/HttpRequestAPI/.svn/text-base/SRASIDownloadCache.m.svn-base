//
//  SRASIDownloadCache.m
//  Discuz2
//
//  Created by 石瑞 on 1/31/12.
//  Copyright (c) 2012 Lone Choy. All rights reserved.
//

#import "SRASIDownloadCache.h"

static SRASIDownloadCache *sharedCache = nil;

@implementation SRASIDownloadCache

@synthesize ignoreParamsForCacheKey = _ignoreParamsForCacheKey;

+ (id)sharedCache
{
	if (!sharedCache) {
		@synchronized(self) {
			if (!sharedCache) {
				sharedCache = [[self alloc] init];
				[sharedCache setStoragePath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ASIHTTPRequestCache"]];
			}
		}
	}
	return sharedCache;
}

+ (NSString *)keyForURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString length] == 0) {
		return nil;
	}

    // 如果存在ignoreParamsForCacheKey,  则处理url后，再计算cacheKey
    SRASIDownloadCache *cache = [SRASIDownloadCache sharedCache];
    if (cache.ignoreParamsForCacheKey != nil && [cache.ignoreParamsForCacheKey count] > 0) {
        NSString *paramString = [url query];
        NSDictionary* params = [paramString queryDictionaryUsingEncoding:NSASCIIStringEncoding];
        NSMutableDictionary *mutableParams = [[params mutableCopy] autorelease];

        for (NSString *k in params) {
            for (NSString *ignoreKey in cache.ignoreParamsForCacheKey) {
                if ([k isEqualToString:ignoreKey]) {
                    [mutableParams removeObjectForKey:k];
                }
            }
        }
        
        NSString *baseUrl = [NSString stringWithFormat:@"%@://%@%@", [url scheme], [url host], [url path]];
        urlString = [baseUrl stringByAddingQueryDictionary:mutableParams];
    }

	// Strip trailing slashes so http://allseeing-i.com/ASIHTTPRequest/ is cached the same as http://allseeing-i.com/ASIHTTPRequest
	if ([[urlString substringFromIndex:[urlString length]-1] isEqualToString:@"/"]) {
		urlString = [urlString substringToIndex:[urlString length]-1];
	}
    
	// Borrowed from: http://stackoverflow.com/questions/652300/using-md5-hash-on-a-string-in-cocoa
	const char *cStr = [urlString UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	NSString *key = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
 	
    return key;
}

@end
