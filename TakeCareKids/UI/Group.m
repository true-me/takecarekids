//
//  Group.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//
#import "Group.h"

@implementation Group

@synthesize imageName; //图片名称
@synthesize imageURL; //图片地址
@synthesize groupName; //Group名称
@synthesize subGroupArr; //Sub Group
@synthesize isRefresh;
@synthesize cellIndexPath;

- (Group *)initWithJsonDictionary:(NSDictionary*)dic {
	if (self = [super init])
    {
//		statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
//		statusKey = [[NSNumber alloc]initWithLongLong:statusId];
//		createdAt = [dic getTimeValueForKey:@"created_at" defaultValue:0];
//		text = [[dic getStringValueForKey:@"text" defaultValue:@""] retain];
//		favorited = [dic getBoolValueForKey:@"favorited" defaultValue:NO];
//		truncated = [dic getBoolValueForKey:@"truncated" defaultValue:NO];
        
		// parse source parameter
		self.imageName = [dic getStringValueForKey:@"imageName" defaultValue:@""];
        self.imageURL = [dic getStringValueForKey:@"imageUrl" defaultValue:@""];
        self.groupName = [dic getStringValueForKey:@"name" defaultValue:@""];
		NSArray *arr = [dic objectForKey:@"subClass"];
        for (id varObject in arr)
        {
            if ([varObject isKindOfClass:[NSDictionary class]])
            {
                SubGroup *subGroupOne = [[SubGroup alloc] init];
                subGroupOne.imageName = [dic getStringValueForKey:@"imageName" defaultValue:@""];
                subGroupOne.imageUrl = [dic getStringValueForKey:@"imageUrl" defaultValue:@""];

                id objClassID = [dic objectForKey:@"classID"];
                if ([objClassID isKindOfClass:[NSNumber class]])
                {
                    subGroupOne.classID = [NSString stringWithFormat:@"%d", [objClassID integerValue]];
                }
                else
                {
                    subGroupOne.classID = objClassID;
                }
                subGroupOne.name = [dic getStringValueForKey:@"name" defaultValue:@""];
                if (!subGroupArr)
                {
                    subGroupArr = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [subGroupArr addObject:subGroupOne];
                [subGroupOne release];
            }
        }
   
	}
	return self;
}

+ (Group *) groupWithJsonDictionary:(NSDictionary*)dic
{
	return [[[Group alloc] initWithJsonDictionary:dic] autorelease];
}


- (NSString*)timestamp
{
//	NSString *_timestamp;
//    // Calculate distance time string
//    //
//    time_t now;
//    time(&now);
//    
//    int distance = (int)difftime(now, createdAt);
//    if (distance < 0) distance = 0;
//    
//    if (distance < 60) {
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
//    }
//    else if (distance < 60 * 60) {  
//        distance = distance / 60;
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
//    }  
//    else if (distance < 60 * 60 * 24) {
//        distance = distance / 60 / 60;
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
//    }
//    else if (distance < 60 * 60 * 24 * 7) {
//        distance = distance / 60 / 60 / 24;
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
//    }
//    else if (distance < 60 * 60 * 24 * 7 * 4) {
//        distance = distance / 60 / 60 / 24 / 7;
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"周前" : @"周前"];
//    }
//    else {
//        static NSDateFormatter *dateFormatter = nil;
//        if (dateFormatter == nil) {
//            dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        }
//        
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];        
//        _timestamp = [dateFormatter stringFromDate:date];
//    }
//    return _timestamp;
    return [NSString stringWithFormat:@""];
}


- (void)dealloc
{
    [imageName release]; //图片名称
    [imageURL release]; //图片地址
    [groupName release]; //Group名称
    [subGroupArr release]; //Sub Group
    [isRefresh release];
	[super dealloc];
}






@end
