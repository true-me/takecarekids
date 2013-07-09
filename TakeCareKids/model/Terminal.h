//
//  SysCfg.h
//  SysCfg
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbHelper.h"

@interface Terminal : NSObject
@property (nonatomic, retain) NSString * tmname;
@property (nonatomic, retain) NSString * tmid;
@property (nonatomic, retain) NSString * tmnum;

+ (id)objectWithProperties:(NSDictionary *)properties;
+ (void)initTable;
+ (NSArray *) getAllModels;
- (void) setToDB;


//+ (NSString *) getCfgValueForName:(NSString *) keyName;
//+ (void) setCfgValue:(NSString *) valueStr ForName:(NSString *) keyName;
@end