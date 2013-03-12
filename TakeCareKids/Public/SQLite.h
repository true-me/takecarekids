//
//  FormViewController.m
//  ArthurElliot
//
//  Created by akunila on 28/11/10.
//  Copyright 2010 __Bridgetree Research Services (P) Ltd, Bangalore, India__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLite : NSObject {
	NSString *SQLFilePath;
	sqlite3 *rdb;
	int success;
	int rowid;
}
@property (nonatomic, retain) NSString *SQLFilePath;
@property (nonatomic, assign) int success;
@property (nonatomic, assign) int rowid;
-(id) initWithSQLFile:(NSString *)sqlfile;
-(void) openDb;
-(void) readDb:(NSString *)sqlQuery;
-(void) insertDb:(NSString *)sqlQuery;
-(NSString *) getColumn:(int)colnum type:(NSString *)text_or_int;
-(BOOL) hasNextRow;
-(BOOL) stepQuery;
-(int) getRowId;
-(void) closeDb;
-(void) updateDb:(NSString *)sqlQuery;

@end
