//
//  DBHelper.m
//  douban-book
//
//  Created by xeodou on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabase.h"

@implementation DBHelper

+ (NSString*)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"doubook.db"];
    return dbPath;
}

+ (void) createTable
{
    FMDatabase *db = [FMDatabase databaseWithPath:[[DBHelper class] getDBPath]];
    if (![db open]) {
        NSLog(@"db not open");
        return;
    }
    NSString *userTable = @"CREATE TABLE IF NOT EXISTS user(name text, uid text,intro text, alt text, avatar text, locid text, locname text, created text, updateTime timestamp)";
    NSString *historyTable = @"CREATE TABLE IF NOT EXISTS history (name text, updateTime timestamp)";
    [db executeUpdate:userTable];
    [db executeUpdate:historyTable];
    [db close];
}

@end
