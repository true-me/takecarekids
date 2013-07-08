//
//  SysCfg.m
//  SysCfgs
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import "SysCfg.h"

@implementation SysCfg
@synthesize cfgName = _cfgName;
@synthesize cfgValue = _cfgValue;
@synthesize extInfo = _extInfo;

-(id)init{
    self = [super init];
    if(self)
    {

    }
    
    return self;
}
- (void)dealloc
{
    [_cfgName release];
    [_cfgName release];
    [_extInfo release];
    [super dealloc];
}

+ (SysCfg*) SysCfgWithJsonDictionary:(NSDictionary*)dic
{
	return [[[SysCfg alloc] initWithJsonDictionary:dic] autorelease];
}
- (SysCfg*) initWithJsonDictionary:(NSDictionary*)dic
{
	if (self = [super init])
    {

    }
   	return self;
}

#pragma mark - User Custom Methods
#pragma mark
+ (void)initTable
{
    if (![[DbHelper sharedSingleton] isExistsTable:[self getClassName]])
    {
        NSString *stmt = [self tableSql:[self getClassName] withPriKey:@"recordID"];
        [[DbHelper sharedSingleton] creatTable:[self getClassName] WithSQL:stmt];
    }
}

+ (NSArray *) getSysCfg
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

+ (NSString *) getCfgValueForName:(NSString *) keyName
{
    [self initTable];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where cfgName ='%@'",[self getClassName], keyName];
    NSDictionary *result = [[DbHelper sharedSingleton] querySingleRecordFromTable:[self getClassName] withStatmt:sql];
    if (result)
    {
        return [result getStringValueForKey:@"cfgValue" defaultValue:@"YES"];
    }
    else
    {
        return @"YES";
    }
}

+ (void) setCfgValue:(NSString *) valueStr ForName:(NSString *) keyName
{
    [self initTable];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where cfgName ='%@'",[self getClassName], keyName];
    NSString *setsql = nil; 
    NSDictionary *result = [[DbHelper sharedSingleton] querySingleRecordFromTable:[self getClassName] withStatmt:sql];
    if (result)
    {
        setsql = [NSString stringWithFormat:@"update %@ set cfgValue ='%@' where cfgName ='%@'",[self getClassName], valueStr, keyName];
    }
    else
    {
        setsql = [NSString stringWithFormat:@"insert into %@(cfgName, cfgValue, extInfo) values('%@', '%@', '%@')",[self getClassName], keyName, valueStr, @""];
    }
    [[DbHelper sharedSingleton] executeByQueue:setsql];
}
@end
