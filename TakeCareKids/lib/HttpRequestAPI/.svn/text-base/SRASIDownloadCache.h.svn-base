//
//  SRASIDownloadCache.h
//  Discuz2
//
//  Created by 石瑞 on 1/31/12.
//  Copyright (c) 2012 Lone Choy. All rights reserved.
//

#import "ASIDownloadCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface SRASIDownloadCache : ASIDownloadCache {
    
    NSArray *_ignoreParamsForCacheKey;
}

@property (nonatomic, retain) NSArray *ignoreParamsForCacheKey;

+ (NSString *)keyForURL:(NSURL *)url;

@end
