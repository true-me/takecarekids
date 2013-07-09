//
//  HttpRequestAPI.m
//  
//
//  Created by rexshi on 11/10/11.
//  Copyright (c) 2011 rexshi. All rights reserved.
//

#import "HttpRequestAPI.h"
#import "sys/utsname.h"

@implementation HttpRequestAPI

@synthesize requestQueue = _requestQueue;
@synthesize request = _request;
@synthesize delegate = _delegate;
@synthesize finishSelector = _finishSelector;
@synthesize finishErrorSelector = _finishErrorSelector;
@synthesize images = _images;
@synthesize customUserInfo = _customUserInfo;
@synthesize useCache = _useCache;
@synthesize enableCache = _enableCache;

#pragma mark - private

/**
 *  get the information of the device and system
 *  "i386"          simulator
 *  "iPod1,1"       iPod Touch
 *  "iPhone1,1"     iPhone
 *  "iPhone1,2"     iPhone 3G
 *  "iPhone2,1"     iPhone 3GS
 *  "iPad1,1"       iPad
 *  "iPhone3,1"     iPhone 4
 */
- (NSString*)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return device;
}

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        self.requestQueue = [[ASINetworkQueue alloc] init];
        [_requestQueue setDelegate:self];
//        [_requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
//        [_requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
//        [_requestQueue setRequestWillRedirectSelector:@selector(request:willRedirectToURL:)];
		[_requestQueue setShouldCancelAllRequestsOnFailure:NO];
        [_requestQueue setShowAccurateProgress:YES];
        self.useCache = NO;
        self.enableCache = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [_request clearDelegatesAndCancel];
    [_request release]; _request = nil;
    
    self.requestQueue = nil;
    
    [_customUserInfo release]; _customUserInfo = nil;
    [_images release]; _images = nil;
    [super dealloc];
}

//- (NSString *)urlEncodeValue:(NSString *)str
//{
//    NSString *resultStr = str;
//    
//    if (![DataCheck isValidString:resultStr]) {
//        return resultStr;
//    }
//    
//    CFStringRef originalString = (CFStringRef) str;
//    CFStringRef leaveUnescaped = CFSTR(" ");
//    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
//    
//    CFStringRef escapedStr;
//    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                         originalString,
//                                                         leaveUnescaped, 
//                                                         forceEscaped,
//                                                         kCFStringEncodingUTF8);
//    
//    if( escapedStr )
//    {
//        NSMutableString *mutableStr = [NSMutableString stringWithString:(NSString *)escapedStr];
//        CFRelease(escapedStr);
//        
//        // replace spaces with plusses
//        [mutableStr replaceOccurrencesOfString:@" "
//                                    withString:@"%20"
//                                       options:0
//                                         range:NSMakeRange(0, [mutableStr length])];
//        resultStr = mutableStr;
//    }
//    
//    return resultStr;
//}

- (NSString *)genSig:(NSDictionary *)params
{
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];

    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in sortedKeys) {
        NSString *value = [params objectForKey:key];
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [value URLEncodedString]];
        [pairs addObject:pair];
    }
    
    NSString *query = [pairs componentsJoinedByString:@"&"];
    query = [query stringByAppendingString:REST_API_KEY];
    
    return [[query dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSString *)getRequestUrl:(NSString *)mod
                     params:(NSDictionary *)params
{
    //    NSString *ts = [NSString stringWithFormat:@"%d", (int)round([[NSDate date] timeIntervalSince1970])];
    
    if (![DataCheck isValidDictionary:params])
    {
        params = [NSDictionary dictionary];
    }
    
    NSMutableDictionary *mutableParams = [[params mutableCopy] autorelease];
    
    //    NSString *osVersion = [NSString stringWithFormat:@"%f", TTOSVersion()];
    //    [mutableParams setObject:osVersion forKey:@"_os_version"];
    //
    //    NSString *deviceType = [self getDeviceType];
    //    [mutableParams setObject:deviceType forKey:@"_device_type"];
    //
    //    [mutableParams setObject:CLOUD_CLIENT_VERSION forKey:@"_client_version"];
    //    [mutableParams setObject:APP_VERSION forKey:@"_app_version"];
    //    [mutableParams setObject:ts forKey:@"_ts"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", REST_API_URL, mod];
    //    NSString *sig = [self genSig:mutableParams];
    //    if (![sig isEmptyOrWhitespace])
    //    {
    //        [mutableParams setObject:sig forKey:@"sig"];
    //    }
    //
    url = [url stringByAddingQueryDictionary:mutableParams];
    
    return url;
}

- (NSString *)getRequestUrlWithoutSig:(NSString *)mod
                     params:(NSDictionary *)params
{
    if (![DataCheck isValidDictionary:params])
    {
        params = [NSDictionary dictionary];
    }
    
    NSMutableDictionary *mutableParams = [[params mutableCopy] autorelease];
    NSString *url = [NSString stringWithFormat:@"%@%@", REST_API_URL, mod];    
    url = [url stringByAddingQueryDictionary:mutableParams];
    return url;
}

- (void)cancel
{
    [_request clearDelegatesAndCancel];
}

- (void) requestWithUrl:(NSString *)url userInfo:(id)userInfo
{
    @try {
        self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];

        // delegate
        [_request setDelegate:self];
        
        // userinfo
        _request.userInfo = userInfo;
        
        // support GZip
        [_request setAllowCompressedResponse:YES];
        
        // response encoding
        _request.defaultResponseEncoding = NSUTF8StringEncoding;
        
        // start request
        [_request startAsynchronous];
        
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}

- (void)callMethodWithMod:(NSString *)mod
                   params:(NSDictionary *)params
               postParams:(NSDictionary *)postParams
                    files:(NSArray *)files
                  cookies:(NSDictionary *)cookies
                   header:(NSDictionary *)header
                 delegate:(id)delegate
                 selector:(SEL)selector
            errorSelector:(SEL)errorSelector
{
   
    NSString *url = [self getRequestUrlWithoutSig:mod params:params];
    NSLog(@"url=%@", url);
    NSLog(@"params=%@", params);
    NSLog(@"postParams=%@", postParams);
    
    NSMutableDictionary *userInfo = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      delegate, @"delegate",
                                      NSStringFromSelector(selector), @"selector",
                                      NSStringFromSelector(errorSelector), @"errorSelector",
                                      nil] autorelease];
    
    if (_customUserInfo && [_customUserInfo count] > 0)
    {
        [userInfo setObject:_customUserInfo forKey:@"customUserInfo"];
    }
    
    @try
    {
        ASIFormDataRequest *aRequest;
        
        // 禁用自动更新网络连接标示符状态
        [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
        
        if ([DataCheck isValidDictionary:postParams])
        {
            aRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            
            // post params
            
            NSString *postBody = [postParams JSONString];
            NSMutableData *postData = [NSMutableData dataWithData:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
            [aRequest setPostBody:postData];
//            for (NSString *key in postParams)
//            {
//                NSString *value = [postParams objectForKey:key];
//                [aRequest setPostValue:value forKey:key];
//            }
            
            // files
            if([DataCheck isValidArray:files])
            {
                for (NSString *filePath in files)
                {
                    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                    {
                        [aRequest setFile:filePath forKey:@"Filedata"];
                    }
                }
            }

            // images
            if ([DataCheck isValidArray:_images])
            {
                for (UIImage *image in _images)
                {
                    if (image != nil && [image isKindOfClass:[UIImage class]])
                    {
                        
//                        int settingQuality = [[SRSettingModel valueForKey:SETTING_PHOTO_QUALITY] intValue];
                        int settingQuality = 0;

                        int quality = 1;
                        if (settingQuality == 0)
                        {
                            quality = 1;
                        }
                        else if (settingQuality == 1)
                        {
                            quality = 0.8;
                        }
                        else if (settingQuality == 2)
                        {
                            quality = 0.6;
                        }
                        
                        NSData* data = UIImageJPEGRepresentation(image, quality);
                        [aRequest addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"image[]"];
                    }
                }
            }
        }
        else
        {
            aRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        }
        
        // delegate
        [aRequest setDelegate:self];
        
        // userinfo
        aRequest.userInfo = userInfo;
        
        // support GZip
        [aRequest setAllowCompressedResponse:YES];

        // charset
        aRequest.defaultResponseEncoding = NSUTF8StringEncoding;

        // user-agent
        [aRequest setUserAgentString:@"iOS_Client"];
        
        [aRequest setTimeOutSeconds:60];
        
        // cache
        if (_enableCache) {
            SRASIDownloadCache *cache = [SRASIDownloadCache sharedCache];
            cache.ignoreParamsForCacheKey = [NSArray arrayWithObjects:@"_ts", @"sig", nil];
            [cache setShouldRespectCacheControlHeaders:NO];
            [aRequest setDownloadCache:cache];
            [aRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [aRequest setCachePolicy:_useCache ? ASIAskServerIfModifiedWhenStaleCachePolicy : ASIDoNotReadFromCacheCachePolicy];
            [aRequest setSecondsToCache:3600 * 24 * 30];
        }

        // cookie
        aRequest.useCookiePersistence = NO;
        if ([DataCheck isValidDictionary:cookies]) {
            NSMutableArray *cookieObjs = [NSMutableArray array];
            
            NSString *domain = [[NSURL URLWithString:url] host];
            NSString *cookieDomain = [NSString stringWithFormat:@".%@", domain];
            
            for (NSString *key in cookies) {
                NSString *value = [cookies objectForKey:key];
                
                NSDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
                [properties setValue:[value URLEncodedString] forKey:NSHTTPCookieValue];
                [properties setValue:key forKey:NSHTTPCookieName];
                [properties setValue:cookieDomain forKey:NSHTTPCookieDomain];
                [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 3] forKey:NSHTTPCookieExpires];
                [properties setValue:@"/" forKey:NSHTTPCookiePath];
                NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
                
                [cookieObjs addObject:cookie];   
            }
            [aRequest setRequestCookies:cookieObjs];
        }
        
        // header
        NSMutableDictionary *defaultHeaders = [NSMutableDictionary dictionary];
        [defaultHeaders setObject:REST_API_HOST forKey:@"Host"];
        if([DataCheck isValidDictionary:header]){
            for (NSString *k in header) {
                NSString *v = [header objectForKey:k];
                [defaultHeaders setObject:v forKey:k];
            }
        }
        [aRequest setRequestHeaders:[[defaultHeaders mutableCopy] autorelease]];
        
        self.request = aRequest;
        
        // start request
//        [aRequest startAsynchronous];        
       [self.requestQueue addOperation:aRequest];

    }
    @catch (NSException *exception) {
        @throw exception;
    }
}

#pragma mark - Operate queue
- (BOOL)isRunning
{
	return ![_requestQueue isSuspended];
}

- (void)start
{
	if( [_requestQueue isSuspended] )
		[_requestQueue go];
}

- (void)pause
{
	[_requestQueue setSuspended:YES];
}

- (void)resume
{
	[_requestQueue setSuspended:NO];
}

- (void)cancelQueue
{
	[_requestQueue cancelAllOperations];
}

#pragma mark - ASINetworkQueueDelegate
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    @try {
        NSString *json = [request responseString];
        NSLog(@"response-> \n%@",json);
        
        json = [json stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // 检查结果
        if ([json isEmptyOrWhitespace])
        {
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"1", @"code",
                                       @"服务器返回为空内容", @"message", nil];
            
            [_delegate performSelector:_finishErrorSelector
                            withObject:request.userInfo
                            withObject:errorInfo];
            
            [request.downloadCache removeCachedDataForRequest:request];
            return;
        }
                
        // 不是json
        if (![json hasPrefix:@"{"] && ![json hasPrefix:@"["]) {
            NSString *code = @"2"; 
            NSString *message = @"服务器返回数据格式错误";
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       code, @"code",
                                       message, @"message", nil];
            
            [_delegate performSelector:_finishErrorSelector
                            withObject:request.userInfo
                            withObject:errorInfo];
            
            [request.downloadCache removeCachedDataForRequest:request];
            return;
        }
        
        NSDictionary *items = [json objectFromJSONString];
        
        int resultCode = [[items objectForKey:@"rst"] intValue];
        NSString *message = [items objectForKey:@"msg"];
        if (resultCode > 0)
        {
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%d", resultCode], @"code",
                                       message, @"message", nil];
            
            [_delegate performSelector:_finishErrorSelector
                            withObject:request.userInfo
                            withObject:errorInfo];
            
            [request.downloadCache removeCachedDataForRequest:request];
            
            return;
        }
                
//        NSDictionary *result = [items objectForKey:@"data"];
        
        // 执行回调        
        [_delegate performSelector:_finishSelector
                        withObject:request.userInfo
                        withObject:items];
    }
    @catch (NSException *exception)
    {
//        if (SR_DEBUG == 1) {
//            [SRMessage errorMessage:[exception reason]];
//            // @throw exception;
//        } else {
//            [SRMessage errorMessage:@"程序错误，请稍后重试"];
//        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"100", @"code",
                               @"网络请求错误，请稍后重试", @"message", nil];
    
    [_delegate performSelector:_finishErrorSelector
                    withObject:request.userInfo
                    withObject:errorInfo];
}

//跳转
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
    NSLog(@"request will redirect");
}

@end
