//
//  FormViewController.m
//  ArthurElliot
//
//  Created by akunila on 28/11/10.
//  Copyright 2010 __Bridgetree Research Services (P) Ltd, Bangalore, India__. All rights reserved.
//

#import "SQLite.h"
static sqlite3_stmt *r_query_statement = nil;
//static sqlite3_stmt *count_statement = nil;

@implementation SQLite
@synthesize SQLFilePath;
@synthesize success;
@synthesize rowid;
///////// INIT FUNCTION //////////////
- (void) dealloc
{
    [SQLFilePath release];
    [super dealloc];
}
-(id) initWithSQLFile:(NSString *)sqlfile 
{
    self = [super init];
    if(self)
    {
        printf("Initialize\n\n");
        NSString *editableSQLfile = [[NSString alloc] initWithFormat:@"edit.%@", sqlfile];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.SQLFilePath = [documentsDirectory stringByAppendingPathComponent:editableSQLfile];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        self.success = [fileManager fileExistsAtPath:self.SQLFilePath];
        if (!self.success) {
            // The writable database does not exist, so copy the default to the appropriate location.
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:sqlfile];
            printf(" Default Path :: %s\n", [defaultDBPath UTF8String]);

            // printf(" Default Path :: %s\n", [defaultDBPath UTF8String]);
        //success = [fileManager removeItemAtPath:SQLFilePath error:&error];
        //if (!success)
        //	NSAssert1(0, @"Failed to rm writable database file with message '%@'.", [error localizedDescription]);
            self.success = [fileManager copyItemAtPath:defaultDBPath toPath:self.SQLFilePath error:&error];
            if (!self.success)
                NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }

        /* // working SQL open code
        NSBundle *mainBundle = [NSBundle mainBundle];	
        SQLFilePath = [mainBundle pathForResource:sqlfile ofType:nil];
         */
         printf(" SQL File path: %s\n", [self.SQLFilePath UTF8String]);
        self.success = 0;
        self.rowid = 0;
        [editableSQLfile release];
    }
	return self;
}

///////// OPEN DATABASE FUNCTION //////////////
-(void)openDb {
//	printf("\n\n------------------------------Inside Open Database----------------------------------\n\n");
	if (sqlite3_open([SQLFilePath UTF8String], &rdb) == SQLITE_OK) {
		//printf("SUCCESS: Opened db - %s\n", [SQLFilePath UTF8String]);
		// printf("\nSUCCESS: Opened db \n");
	} else {
		printf("ERROR: Unable to open db - %s\n", [SQLFilePath UTF8String]);
	}
}

///////// READ DATABASE FUNCTION //////////////
-(void) readDb:(NSString *)sqlQuery {
    printf("SUCCESS: sqlQuery - \n");
	//printf("SUCCESS: sqlQuery - %s\n", [sqlQuery UTF8String]);
	if (r_query_statement == nil) {
        const char *sql = [sqlQuery UTF8String];
        if (sqlite3_prepare_v2(rdb, sql, -1, &r_query_statement, NULL) != SQLITE_OK) {
			printf(" ERROR !! \n\n");
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(rdb));
        }
    }
}

///////// INSERT DATABASE FUNCTION //////////////
-(void) insertDb:(NSString *)sqlQuery {
	
        printf("SUCCESS: sqlQuery - \n");
	//printf("SUCCESS: sqlQuery - %s\n", [sqlQuery UTF8String]);
	if (r_query_statement == nil) {
        const char *sql = [sqlQuery UTF8String];
        if (sqlite3_prepare_v2(rdb, sql, -1, &r_query_statement, NULL) != SQLITE_OK) {
			printf(" ERROR !! \n\n");
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(rdb));
        }
    }
	
	if(SQLITE_DONE != sqlite3_step(r_query_statement))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(rdb));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		rowid = sqlite3_last_insert_rowid(rdb);
	
	//Reset the add statement.
	sqlite3_reset(r_query_statement);
    //sqlite3_finalize(r_query_statement);
}


///////// UPDATE DATABASE FUNCTION //////////////
-(void) updateDb:(NSString *)sqlQuery
{
    printf("SUCCESS: sqlQuery - \n");
	//printf("SUCCESS: sqlQuery - %s\n", [sqlQuery UTF8String]);
	if (r_query_statement == nil) {
        const char *sql = [sqlQuery UTF8String];
        if (sqlite3_prepare_v2(rdb, sql, -1, &r_query_statement, NULL) != SQLITE_OK) {
			printf(" ERROR !! \n\n");
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(rdb));
        }
    }
	[self hasNextRow];
}

///////// RETURN COLUMN BY COLUMN DATA FUNCTION //////////////
-(BOOL) hasNextRow {
	if (r_query_statement != nil) {
		success = sqlite3_step(r_query_statement);
		rowid++;
	}
	return (success == SQLITE_ROW) ? YES : NO;
}

-(BOOL) stepQuery {
	return [self hasNextRow];
}

// Should run hasNextRow before getColumn
-(NSString *) getColumn:(int)colnum type:(NSString *)text_or_int {
	NSString *value = nil;
	
	if (success == SQLITE_ROW) {
		if ([text_or_int isEqualToString:@"text"])
		{
			const unsigned char *colVal = sqlite3_column_text(r_query_statement, colnum);
			value = (colVal == NULL) ? @"" : [NSString stringWithUTF8String:(char *)colVal];
//			value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(r_query_statement, colnum)];
		} else if ([text_or_int isEqualToString:@"int"])
		{
			value = [NSString stringWithUTF8String:(char *)sqlite3_column_int(r_query_statement, colnum)];
		}
    }
	return value;
}

-(int) getRowId {
	return rowid;
}

///////// INIT FUNCTION //////////////
-(void) closeDb {
//	printf("\n\n--------------------Inside Close Database----------------------------------\n\n");
	sqlite3_reset(r_query_statement);
	sqlite3_finalize(r_query_statement);
	
	// Close the database
	int retClose = sqlite3_close(rdb);
	if (retClose != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(rdb));
	}
	r_query_statement = nil;
	rowid=0;
	success=0;
}


@end
