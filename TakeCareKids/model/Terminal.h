//
//  SysCfg.h
//  SysCfg
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbHelper.h"

@interface Terminal : NSObject {

}
@property (nonatomic, retain) NSString * tmname;
@property (nonatomic, retain) NSString * tmid;
@property (nonatomic, retain) NSString * tmnum;

//+(SysCfg *) sharedSingleton;
- (Terminal*) initWithJsonDictionary:(NSDictionary*)dic;
+ (Terminal*) TerminalWithJsonDictionary:(NSDictionary*)dic;
+ (void)initTable;
+ (NSArray *) getAllModels;
//+ (NSString *) getCfgValueForName:(NSString *) keyName;
//+ (void) setCfgValue:(NSString *) valueStr ForName:(NSString *) keyName;
@end