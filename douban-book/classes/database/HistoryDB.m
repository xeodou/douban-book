//
//  HistoryDB.m
//  douban-book
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "HistoryDB.h"
#import "FMDatabase.h"
#import "DBHelper.h"

@interface HistoryDB()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation HistoryDB
@synthesize db;

- (id) init
{
    self = [super init];
    if(self){
        if(db == nil){
            db = [FMDatabase databaseWithPath:[DBHelper getDBPath]];
        }
    }
    return  self;
}

- (BOOL) insertHistory:(NSString*)str
{
    if (![db open]) {
        return NO;
    }
    if ([self searchKey:str] != nil) {
        return YES;
    }
    NSString *sql = @"insert into history (name, updateTime) values(?, ?)";
    return [db executeUpdate:sql, str, [NSString stringWithFormat:@"%ld", time(NULL)]];
}

- (NSString*) searchKey:(NSString*)str
{
    if (![db open]) {
        return nil;
    }
    NSString *sql = @"select * from history where name = ?";
    FMResultSet *result = [db executeQuery:sql, str];
    [result close];
    if (![result next]) {
        return nil;
    }
    return str;
}

- (NSArray*) getAllHistory
{
    if (![db open]) {
        return nil;
    }
    NSString *sql = @"select * from history";
    FMResultSet *result = [db executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while([result next]){
        [array addObject:[result objectForColumnName:@"name"]];
    }
    [result close];
    return array;
}

- (BOOL)deleteString:(NSString*)str
{
    if (![db open]) {
        return NO;
    }
    NSString *sql = nil;
    if (str) {
        sql = [NSString stringWithFormat:@"delete from history where name = '%@'", str];
    } else {
        sql = @"delete from history where name = ''";
    }
    return [db executeUpdate:sql];
}

- (void)dealloc
{
    [self setDb:nil];
}

- (void)close
{
    [db close];
}

@end
