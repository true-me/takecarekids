//
//  Group.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "NSDictionaryAdditions.h"
#import "SubGroup.h"

@interface Group : NSObject
{
	NSString *imageName; //图片名称
	NSString *imageURL; //图片地址
	NSString *groupName; //Group名称
    NSMutableArray *subGroupArr; //Sub Group
    NSIndexPath *cellIndexPath;    
}
@property (nonatomic, retain) NSString *imageName; //图片名称
@property (nonatomic, retain) NSString *imageURL; //图片地址
@property (nonatomic, retain) NSString *groupName; //Group名称
@property (nonatomic, retain) NSMutableArray *subGroupArr; //Sub Group
@property (nonatomic, readonly) NSString*   timestamp;
@property (nonatomic, retain) NSString *isRefresh;
@property (nonatomic, retain) NSIndexPath    *cellIndexPath;

- (NSString*)timestamp;
+ (Group*) groupWithJsonDictionary:(NSDictionary*)dic;
@end
