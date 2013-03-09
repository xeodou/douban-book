//
//  UserDB.m
//  douban-book
//
//  Created by xeodou on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UserDB.h"
#import "FMDatabase.h"
#import "DBHelper.h"

@interface UserDB()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation UserDB
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

- (BOOL)insertUser:(DOUUser *)user
{
    if(![db open])
        return NO;
    NSString *str = @"insert into user (name, uid, intro, alt, avatar, locid, locname, created, updateTime) values (?,?,?,?,?,?,?,?,?)";
    return [db executeUpdate:str, user.name, user.uid, user.desc , user.alt, user.avatar, user.locId, user.locName, user.created, [NSString stringWithFormat:@"%ld", time(NULL)]];
}

- (DOUUser*) getUser
{
    if (![db open]) {
        return nil;
    }
    NSString *sql = @"select * from user";
    DOUUser *user = nil;
    FMResultSet *res = [db executeQuery:sql];
    while ([res next]) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[res stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[res stringForColumn:@"uid"] forKey:@"uid"];
        [dic setObject:[res stringForColumn:@"intro"] forKey:@"desc"];
        [dic setObject:[res stringForColumn:@"alt"] forKey:@"alt"];
        [dic setObject:[res stringForColumn:@"avatar"] forKey:@"avatar"];
        [dic setObject:[res stringForColumn:@"locid"] forKey:@"loc_id"];
        [dic setObject:[res stringForColumn:@"locname"] forKey:@"loc_name"];
        [dic setObject:[res stringForColumn:@"created"] forKey:@"created"];
        user = [[DOUUser alloc] initWithDictionary:dic];
    }
    [res close];
    return user;
}

- (BOOL)deleteUser
{
    if(![db open])
        return NO;
    NSString *sql = @"delete from user Where uid != ''";
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
