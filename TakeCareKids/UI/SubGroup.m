//
//  SubGroup.m
//  TakeCareKids
//
//  Created by Jeffrey Ma on 3/22/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import "SubGroup.h"

@implementation SubGroup

@synthesize classID;
@synthesize imageName;
@synthesize imageUrl;
@synthesize name;

- (void)dealloc
{
    [classID release];
    [imageName release];
    [imageUrl release];
    [name release];
    [super dealloc];
}

@end
