//
//  MemberDAL.m
//  DuoTin
//
//  Created by Tom  on 12/2/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import "MemberDAL.h"
#import "SQLite.h"
#import "UserModel.h"
#import "CommonMethods.h"
#import "JSONKit.h"
//#import "ListenHistoryModel.h"

@implementation MemberDAL
@synthesize delegate;
@synthesize request = _request;
@synthesize formRequest = _formRequest;

static MemberDAL *_memberDAL;

+(MemberDAL *)memberDAL
{
    if (nil == _memberDAL) {
        _memberDAL = [[MemberDAL alloc] init];
    }
    return _memberDAL;
}

#pragma mark Life Cycle
- (void)cancel
{
    [_request clearDelegatesAndCancel];
}

-(void)cancelForm
{
    [_formRequest clearDelegatesAndCancel];
}

-(void) dealloc
{
    delegate = nil;
	[_request release];
    [_formRequest release];
	[super dealloc];
}

-(BOOL)UserExists
{
    BOOL isExist;
	isExist = NO;
	
	SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
	[sqlobj openDb];
	
	NSString *query=[NSString stringWithFormat:@"Select * from UserInfo"];
	[sqlobj readDb:query];
	
	while ([sqlobj hasNextRow])
	{
		isExist = YES;
	}
	[sqlobj closeDb];
	[sqlobj release];
	
	return isExist;
}

+(void)DeleteUser
{
    SQLite *objsql = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    NSString *str = @"delete from UserInfo";
    [objsql openDb];
    [objsql updateDb:str];
    [objsql closeDb];
    [objsql release];
}

+(void)DeleteUserListenData
{
    SQLite *objsql = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    // 删除收藏
    
    // 删除关注
    
    // 删除收听历史
    NSString *str1 = @"delete from tblLastPlayModels";
    [objsql openDb];
    [objsql updateDb:str1];
    [objsql closeDb];

    // 删除最后的播放进度
    NSString *str2 = @"delete from tbllistenhistory";
    [objsql openDb];
    [objsql updateDb:str2];
    [objsql closeDb];
    [objsql release];
}


+(UserModel*)GetUserInfo
{
    
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    [sqlobj openDb];
	
	NSString *query=[NSString stringWithFormat:@"Select id,username,[password],realname,sex,qq,mobile,image_url,token from UserInfo"];
	[sqlobj readDb:query];
	UserModel *loginModel = [[[UserModel alloc] init] autorelease];
	while ([sqlobj hasNextRow])
	{
		loginModel.sID = [sqlobj getColumn:0 type:@"text"];
		loginModel.username = [sqlobj getColumn:1 type:@"text"];
        loginModel.pwd = [sqlobj getColumn:2 type:@"text"];
        loginModel.realname = [sqlobj getColumn:3 type:@"text"];
        loginModel.sex = [sqlobj getColumn:4 type:@"text"];
        loginModel.qq = [sqlobj getColumn:5 type:@"text"];
        loginModel.mobile = [sqlobj getColumn:6 type:@"text"];
        loginModel.image_url = [sqlobj getColumn:7 type:@"text"];
        loginModel.token = [sqlobj getColumn:8 type:@"text"];        
	}
	[sqlobj closeDb];
	[sqlobj release];
    return loginModel;
}

+(void)SaveUser:(UserModel*)model
{
    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
    
    NSString *str = [NSString stringWithFormat:@"insert into UserInfo(id,username,[password],realname,sex,qq,mobile,image_url,token) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                     model.sID,
                     model.username,
                     model.pwd,
                     model.realname,
                     model.sex,
                     model.qq,
                     model.mobile,
                     model.image_url,
                     model.token];
    
    [sqlobj openDb];
    [sqlobj insertDb:str];
    [sqlobj closeDb];
    [sqlobj release];
}

-(void)PostRegWithURL:(NSString*)urlString withTag:(NSInteger)tag withDelegate:(id)del email:(NSString*)email loginid:(NSString*)loginid pwd:(NSString*)pwd mac:(NSString *)macadress
{
    self.delegate = del;
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.formRequest = [ASIFormDataRequest requestWithURL:url];
    
    [self.formRequest setPostValue:email forKey:@"email"];
    [self.formRequest setPostValue:loginid forKey:@"username"];
    [self.formRequest setPostValue:pwd forKey:@"password"];
    [self.formRequest setPostValue:pwd forKey:@"repassword"];
    [self.formRequest setPostValue:macadress forKey:@"imei"];
    
    [self.formRequest setPostFormat:ASIMultipartFormDataPostFormat];
    [self.formRequest setTag:tag];
    [self.formRequest setDelegate:self];
    [self.formRequest startAsynchronous];
}

-(void)PostForgetEmailWithURL:(NSString*)urlString withTag:(NSInteger)tag withDelegate:(id)del email:(NSString*)email
{
    self.delegate = del;
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.formRequest = [ASIFormDataRequest requestWithURL:url];
    
    [self.formRequest setPostValue:email forKey:@"email"];
    [self.formRequest setPostFormat:ASIMultipartFormDataPostFormat];
    [self.formRequest setTag:tag];
    [self.formRequest setDelegate:self];
    [self.formRequest startAsynchronous];

}

-(void)PostLoginWithURL:(NSString*)urlString withTag:(NSInteger)tag withDelegate:(id)del loginid:(NSString*)loginid pwd:(NSString*)pwd mac:(NSString *)macadress
{
    self.delegate = del;
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.formRequest = [ASIFormDataRequest requestWithURL:url];
    
    [self.formRequest setPostValue:loginid forKey:@"username"];
    [self.formRequest setPostValue:pwd forKey:@"password"];
    [self.formRequest setPostValue:macadress forKey:@"imei"];
    
    [self.formRequest setPostFormat:ASIMultipartFormDataPostFormat];
    [self.formRequest setTag:tag];
    [self.formRequest setDelegate:self];
    [self.formRequest startAsynchronous];
}

-(void)GetUserInfoWithURL:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del
{
    self.delegate = del;
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
    _request.tag = tag;
    [_request setDelegate:self];
    [_request startAsynchronous];
}

-(void)GetMemberInfoWithURL:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del
{
    self.delegate = del;
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
    _request.tag = tag;
    [_request setDelegate:self];
    [_request startAsynchronous];
}

-(void)PostVersionWithURL:(NSString*)urlString withTag:(NSInteger)tag withDelegate:(id)del version:(NSString*)version
{
    self.delegate = del;
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.formRequest = [ASIFormDataRequest requestWithURL:url];
    
    [self.formRequest setPostValue:version forKey:@"version"];
    [self.formRequest setPostFormat:ASIMultipartFormDataPostFormat];
    [self.formRequest setTag:tag];
    [self.formRequest setDelegate:self];
    [self.formRequest startAsynchronous];
}

-(void)GetUserContentFollowedWithURL:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del
{
    self.delegate = del;
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
    _request.tag = tag;
    [_request setDelegate:self];
    [_request startAsynchronous];
}

//get concern program list
-(void)GetConcernAlbums:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del
{
    self.delegate = del;
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.request setCachePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
    _request.tag = tag;
    [_request setDelegate:self];
    [_request startAsynchronous];
}

-(void)CancelConcernAlbums:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del delarr:(NSMutableArray*)delarr
{
    self.delegate = del;
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.formRequest = [ASIFormDataRequest requestWithURL:url];
    
    NSString *userToken = [MemberDAL GetUserInfo].token;
    
    [self.formRequest setPostValue:userToken forKey:@"token"];
    NSMutableString *delID = [NSMutableString new];
    for(int i=0;i<delarr.count;i++)
    {
        [delID appendString:[NSString stringWithFormat:@"%@,", [delarr objectAtIndex:i]]];
    }
    
    NSString *strDel = [NSString stringWithFormat:@"[%@]", [[NSString stringWithFormat:@"%@", delID] substringToIndex:delID.length-1]];
    [delID release];
    
    [self.formRequest setPostValue:strDel forKey:@"concerns_id"];
    
    [self.formRequest setPostFormat:ASIMultipartFormDataPostFormat];
    [self.formRequest setTag:tag];
    [self.formRequest setDelegate:self];
    [self.formRequest startAsynchronous];
}

-(void)CancelCollectContents:(NSString *)urlString withTag:(NSInteger )tag withDelegate:(id)del delarr:(NSMutableArray*)delarr
{
    self.delegate = del;
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.formRequest = [ASIFormDataRequest requestWithURL:url];
    
    NSString *userToken = [MemberDAL GetUserInfo].token;
    
    [self.formRequest setPostValue:userToken forKey:@"token"];
    NSMutableString *delID = [NSMutableString new];
    for(int i=0;i<delarr.count;i++)
    {
        [delID appendString:[NSString stringWithFormat:@"%@,", [delarr objectAtIndex:i]]];
    }
    NSString *strDelID = [NSString stringWithString:delID];
    NSString *subStr = [strDelID substringToIndex:strDelID.length-1];
    NSString *strDel = [NSString stringWithFormat:@"[%@]", subStr];
    [delID release];
    
    [self.formRequest setPostValue:strDel forKey:@"content_id"];
    
    [self.formRequest setPostFormat:ASIMultipartFormDataPostFormat];
    [self.formRequest setTag:tag];
    [self.formRequest setDelegate:self];
    [self.formRequest startAsynchronous];
}

#pragma mark Request Finished & Faild
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSData *respData = [request responseData];
    
    if(request.tag == GET_CONTENT_FOLLOWED)
    {
        if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
        {
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
            [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
        }
    }
    
    if(request.tag == GET_USER_INFO)
    {
        if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
        {
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
            [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
        }
    }
    
    if(request.tag == TAG_USER_REG)
    {
        if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
        {
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
            [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
        }
    }
    if(request.tag == TAG_USER_LOGIN)
    {
        if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
        {
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
            [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
        }
    }
    if(request.tag == TAG_USER_CONCERN)
    {
        if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
        {
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
            [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
        }
    }
    if(request.tag == TAG_USER_CANCELCONCERN)
    {
        if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
        {
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
            [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
        }
    }
    if(request.tag == TAG_USER_MAIN)
    {
        if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
        {
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
            [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
        }
    }
    if (request.tag == TAG_USER_FORGET)
    {
        if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
        {
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
            }
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
            [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
        }
    }
    if (request.tag == TAG_APP_VERSION)
    {
            if([request responseStatusCode] == 204 || [request responseStatusCode] == 400 || [request responseStatusCode] == 404 || [request responseStatusCode] == 201)
            {
                if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                    [self.delegate ReturnDic:[OC("{}") objectFromJSONData] withTag:request.tag];
                }
                return;
            }
            
            if ([self.delegate respondsToSelector:@selector(ReturnDic:withTag:)]) {
                [self.delegate ReturnDic:[respData objectFromJSONData] withTag:request.tag];
            }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if (error)
    {
        if ([self.delegate respondsToSelector:@selector(ReturnFailed:withTag:)]) {
            [self.delegate ReturnFailed:error withTag:request.tag];
        }
    }
}

#pragma mark Read/Write listen history from sqlite data
//-(void) saveListenHistory:(AlbumContentModel *) contentModel
//{
//    SQLite *objsqld = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
//    
//    NSString *queryCount = [NSString stringWithFormat:@"select count(id) as totalCount from tbllistenhistory"];
//    [objsqld openDb];
//	[objsqld readDb:queryCount];
//    
//    NSInteger totalCount = 0;
//    if([objsqld hasNextRow])
//    {
//        totalCount = [[objsqld getColumn: 0 type:@"text"] intValue];
//    }
//    [objsqld closeDb];
//    
//    BOOL isMoreThan100 = NO;
//    if (totalCount >= 100)
//    {
//        isMoreThan100 = YES;
//    }
//
//    if(isMoreThan100)
//    {
//        [objsqld openDb];        
//        NSString *queryCount = [NSString stringWithFormat:@"delete from tbllistenhistory where  rowid in (SELECT  rowid  FROM tbllistenhistory order by rowid asc, rowid limit 1)"];
//        [objsqld updateDb:queryCount];
//        [objsqld closeDb];
//    }
//    
//	NSString *query=[NSString stringWithFormat:@"select id from tbllistenhistory where id = '%@' ", contentModel.sID];
//    [objsqld openDb];    
//	[objsqld readDb:query];
//    BOOL isExistHistory = NO;
//    isExistHistory = [objsqld hasNextRow];
//    [objsqld closeDb];
//    NSString *sqlSentence = nil;
//    
//    NSString *sCreateTime = [CommonMethods stringhhmmssFromDate:[NSDate date]];
//    
//    if(isExistHistory)
//    {
//        // just update its create time
//        sqlSentence = sqlSentence = [NSString stringWithFormat:@"update tbllistenhistory set createtime = '%@' where id ='%@'", sCreateTime, contentModel.sID];
//        [objsqld openDb];
//        [objsqld updateDb:sqlSentence];
//        [objsqld closeDb];
//    }
//    else
//    {
//        sqlSentence = [NSString stringWithFormat:@"insert into tbllistenhistory(id,title,runtime,size,newstatus,listen_url,download_url,playtimes,image_url,album_id,collect_url,collected,file_size_16,file_size_32,file_url,seconds,album_image_url,album_title,upload_by,fileName, createtime) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d','%d','%d','%@','%d','%@','%@','%@','%@','%@')",
//                                 contentModel.sID,
//                                 contentModel.title,
//                                 contentModel.runtime,
//                                 contentModel.size,
//                                 contentModel.newstatus,
//                                 contentModel.listen_url,
//                                 contentModel.download_url,
//                                 contentModel.playtimes,
//                                 contentModel.image_url,
//                                 contentModel.album_id,
//                                 contentModel.collect_url,
//                                 contentModel.collected,
//                                 contentModel.file_size_16,
//                                 contentModel.file_size_32,
//                                 contentModel.file_url,
//                                 contentModel.seconds,
//                                 contentModel.album_image_url,
//                                 contentModel.album_title,
//                                 contentModel.upload_by,
//                                 @"",
//                                 sCreateTime
//                                 ];
//        [objsqld openDb];
//        [objsqld insertDb:sqlSentence];
//        [objsqld closeDb];
//    }
//	[objsqld release];
//
//}
//-(NSMutableArray*)ReadListenHistory
//{
//    SQLite *sqlobj = [[SQLite alloc] initWithSQLFile:@"duotin.sqlite"];
//    [sqlobj openDb];
//   
////	NSString *query=[NSString stringWithFormat:@"select id,mp3_url,title,logtime from listenHistory order by logtime desc"];
//    
//    NSString *query=[NSString stringWithFormat:@"select id,title,runtime,size,newstatus,listen_url,download_url,playtimes,image_url,album_id,collect_url,collected,file_size_16,file_size_32,file_url,seconds,album_image_url,album_title,upload_by, createtime from [tbllistenhistory] ORDER BY createtime desc"];
//	[sqlobj readDb:query];
//	NSMutableArray *arrHistory = [[[NSMutableArray alloc] init] autorelease];
//	while ([sqlobj hasNextRow])
//	{
//        ListenHistoryModel *lhm =[[ListenHistoryModel alloc] init];
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
//        lhm.acm = acm;
//        lhm.createtime =    [sqlobj getColumn:19 type:@"text"] ;
//        [arrHistory addObject:lhm];
//        [acm release];
//        [lhm release];
//	}
//	[sqlobj closeDb];
//	[sqlobj release];
//    return arrHistory;
//}
//
@end
