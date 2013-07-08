//
//  SCDBHelper.h
//  WishOrange
//
//  Created by Jeffrey Ma on 5/13/13.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "SCDBUtils.h"

@interface SCDBHelper : NSObject
{
    FMDatabase* fmdb;
    FMDatabaseQueue* bindingQueue;
    NSString* dbname;
}

@property(strong, nonatomic) FMDatabase* fmdb;
@property(strong, nonatomic) FMDatabaseQueue* bindingQueue;
@property(retain, nonatomic) NSString* dbname;

+(SCDBHelper*) sharedSingleton;
-(BOOL) creatDatabase;
-(BOOL) creatTable:(NSString *) tableName WithSQL:(NSString *) sqlStatmt;
-(NSDictionary *) querySingleRecordFromTable:(NSString *) tableName withStatmt:(NSString *) sqlStatmt;
-(BOOL) updateRecordFromTable:(NSString *) tableName withStatmt:(NSString *) sqlStatmt;
@end
