//
//  SysCfg.h
//  SysCfg
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbHelper.h"

@interface SysCfg : NSObject {

}

@property (nonatomic, retain) NSString * cfgName;
@property (nonatomic, retain) NSString * cfgValue;
@property (nonatomic, retain) NSString * extInfo;

//+(SysCfg *) sharedSingleton;
- (SysCfg*) initWithJsonDictionary:(NSDictionary*)dic;
+ (SysCfg*) SysCfgWithJsonDictionary:(NSDictionary*)dic;
+ (void)initTable;
+ (NSArray *) getSysCfg;
+ (NSString *) getCfgValueForName:(NSString *) keyName;
+ (void) setCfgValue:(NSString *) valueStr ForName:(NSString *) keyName;
@end