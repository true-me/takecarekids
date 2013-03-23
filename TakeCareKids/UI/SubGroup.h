//
//  SubGroup.h
//  TakeCareKids
//
//  Created by Jeffrey Ma on 3/22/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSDictionaryAdditions.h"

@interface SubGroup : NSObject
{
    NSString * classID;
    NSString * imageName;
    NSString * imageUrl;
    NSString * name;
}

@property (nonatomic, retain) NSString * classID;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;

@end
