//
//  SCDBHelper.m
//  WishOrange
//
//  Created by Jeffrey Ma on 5/13/13.
//
//

#import "SCDBHelper.h"

@implementation SCDBHelper
@synthesize fmdb;
@synthesize bindingQueue;
@synthesize dbname;

static SCDBHelper *sharedSingleton = nil;

- (id)init
{
    self = [super init];
    if (self)
    {
        fmdb =[FMDatabase databaseWithPath:[SCDBHelper databaseFilePath]];
        if (![fmdb  open])
        {
            [fmdb release];
            return self;
        }
    }
    return self;
}

+(SCDBHelper *) sharedSingleton
{
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[SCDBHelper alloc] init];
        }
        
        DLog(@"SCDBHelper.sharedSingleton:%d", sharedSingleton.retainCount);
        return sharedSingleton;
    }
}

- (void)dealloc
{
    [fmdb release];
    [bindingQueue release];
    [dbname release];
    [super dealloc];
}

+(NSString *) databaseFilePath
{
    return [SCDBUtils getPathForDocuments:@"communitydb.db" inDir:@"db"];;
}

-(BOOL)creatDatabase
{
    self.fmdb = [[FMDatabase databaseWithPath:[SCDBHelper databaseFilePath]] retain];
    return [self.fmdb open];
}

-(BOOL) creatTable:(NSString *) tableName WithSQL:(NSString *) sqlStatmt
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.fmdb)
    {
        [self creatDatabase];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.fmdb open])
    {
        DLog(@"数据库打开失败");
        return FALSE;
    }
    //为数据库设置缓存，提高查询效率
    [self.fmdb setShouldCacheStatements:YES];
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.fmdb tableExists:tableName])
    {
        DLog(@"创建");
        return [self.fmdb executeUpdate:sqlStatmt];
    }
    return FALSE;
}

-(NSDictionary *) querySingleRecordFromTable:(NSString *) tableName withStatmt:(NSString *) sqlStatmt
{
    //获取数据
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.fmdb)
    {
        [self creatDatabase];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.fmdb open])
    {
        DLog(@"数据库打开失败");
        return nil;
    }
    //为数据库设置缓存，提高查询效率
    [self.fmdb setShouldCacheStatements:YES];
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.fmdb tableExists:tableName])
    {
        return nil;
    }
    
    if ([fmdb open])
    {
        FMResultSet *rs = [fmdb executeQuery:sqlStatmt];
        NSMutableDictionary *rowDict = nil;
        while ([rs next])
        {
            
            rowDict = [NSMutableDictionary dictionaryWithDictionary:[rs resultDictionary]];
            break;
        }
        [rs close];
        [fmdb close];
        return rowDict;
    }
    else
    {
        return nil;
    }
}

-(BOOL) updateRecordFromTable:(NSString *) tableName withStatmt:(NSString *) sqlStatmt
{
    //获取数据
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!self.fmdb)
    {
        [self creatDatabase];
    }
    
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![self.fmdb open])
    {
        DLog(@"数据库打开失败");
        return NO;
    }
    //为数据库设置缓存，提高查询效率
    [self.fmdb setShouldCacheStatements:YES];
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if(![self.fmdb tableExists:tableName])
    {
        return NO;
    }
    
    if ([fmdb open])
    {
        [fmdb beginTransaction];
        BOOL result = [fmdb executeUpdate:sqlStatmt];
        [fmdb commit];
        [fmdb close];
        return result;
    }
    else
    {
        return NO;
    }
}
@end
