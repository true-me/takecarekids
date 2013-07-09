//
//  SysCfg.m
//  SysCfgs
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import "Terminal.h"

@implementation Terminal
@synthesize tmname = _tmname;
@synthesize tmid = _tmid;
@synthesize tmnum = _tmnum;

-(id)init{
    self = [super init];
    if(self)
    {
        [Terminal initTable];
    }
    return self;
}
- (void)dealloc
{
    [_tmname release];
    [_tmid release];
    [_tmnum release];
    [super dealloc];
}

+ (id)objectWithProperties:(NSDictionary *)properties {
    return [[[self alloc] initWithProperties:properties] autorelease];
}

- (id)initWithProperties:(NSDictionary *)properties {
    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

#pragma mark - User Custom Methods
#pragma mark
+ (void)initTable
{
    if (![[DbHelper sharedSingleton] isExistsTable:[self getClassName]])
    {
        NSString *stmt = [self tableSql:[self getClassName] withPriKey:@"tmid"];
        [[DbHelper sharedSingleton] creatTable:[self getClassName] WithSQL:stmt];
    }
}

+ (NSArray *) getAllModels
{
    [self initTable];
    NSArray *arr = [[DbHelper sharedSingleton] queryDbToObjectArray:[self class]];
    if (arr.count > 0)
    {
        return arr;
    }
    else
    {
        return nil;
    }
    return arr;
}

- (void) setToDB
{
    [Terminal initTable];
    
    if ([[DbHelper sharedSingleton] isExistsWithObject:self])
    {
        [[DbHelper sharedSingleton] updateObject:self forKey:@"tmid"];
    }
    else
    {
        [[DbHelper sharedSingleton] insertObject:self];
    }
}
//+ (NSString *) getCfgValueForName:(NSString *) keyName
//{
//    [self initTable];
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ where cfgName ='%@'",[self getClassName], keyName];
//    NSDictionary *result = [[DbHelper sharedSingleton] querySingleRecordFromTable:[self getClassName] withStatmt:sql];
//    if (result)
//    {
//        return [result getStringValueForKey:@"cfgValue" defaultValue:@"YES"];
//    }
//    else
//    {
//        return @"YES";
//    }
//}
//
//+ (void) setCfgValue:(NSString *) valueStr ForName:(NSString *) keyName
//{
//    [self initTable];
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ where cfgName ='%@'",[self getClassName], keyName];
//    NSString *setsql = nil; 
//    NSDictionary *result = [[DbHelper sharedSingleton] querySingleRecordFromTable:[self getClassName] withStatmt:sql];
//    if (result)
//    {
//        setsql = [NSString stringWithFormat:@"update %@ set cfgValue ='%@' where cfgName ='%@'",[self getClassName], valueStr, keyName];
//    }
//    else
//    {
//        setsql = [NSString stringWithFormat:@"insert into %@(cfgName, cfgValue, extInfo) values('%@', '%@', '%@')",[self getClassName], keyName, valueStr, @""];
//    }
//    [[DbHelper sharedSingleton] executeByQueue:setsql];
//}
@end
