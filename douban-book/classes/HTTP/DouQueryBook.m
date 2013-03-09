//
//  DouQueryBook.m
//  douban-book
//
//  Created by xeodou on 13-1-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DouQueryBook.h"

@implementation DouQueryBook

+ (id)queryForBookById:(NSString*)bookId
{
    NSString *subPath = [NSString stringWithFormat:@"/v2/book/%@", bookId];
    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:subPath parameters:nil];
    return query;
}

+ (id)queryForBookByIsbn:(NSString*)isbn
{
    NSString *subPath = [NSString stringWithFormat:@"/v2/book/isbn/%@", isbn];
    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:subPath parameters:nil];
    return query;
}

+ (id)queryForBookBykey:(NSString*)key tag:(NSString*)tag start:(NSInteger)start count:(NSInteger)count
{
    NSString *subPath=[NSString stringWithFormat:@"/v2/book/search"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(key != nil)
        [dic setObject:key forKey:@"q"];
    if(tag != nil)
        [dic setObject:tag forKey:@"tag"];
    if(start != 0)
        [dic setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
    if(count != 0)
        [dic setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:subPath parameters:dic];
    return query;
}

+ (id)queryForBookByCollection:(NSString*)uid status:(NSString*)status start:(NSInteger)start count:(NSInteger)count
{
    NSString *path = [NSString stringWithFormat:@"/v2/book/user/%@/collections",uid];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:status forKey:@"status"];
    if(start != 0)
        [dic setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
    if(count != 0)
        [dic setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:path parameters:dic];
    return query;
}

+ (id) queryForAnnotationByName:(NSString*)uid start:(NSInteger)start count:(NSInteger)count
{
    NSString *path = [NSString stringWithFormat:@"/v2/book/user/%@/annotations", uid];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(start != 0)
        [dic setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
    if(count != 0)
        [dic setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    return [[DOUQuery alloc] initWithSubPath:path parameters:dic];
}

+ (id)queryForAnnotaionByBookId:(NSString*)bid start:(NSInteger)start count:(NSInteger)count
{
    NSString *path = [NSString stringWithFormat:@"/v2/book/%@/annotations", bid];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(start != 0)
        [dic setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
    if(count != 0)
        [dic setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    return [[DOUQuery alloc] initWithSubPath:path parameters:dic];
}

+ (id)addAnnotationForBook:(NSString*)bid withParams:(NSMutableDictionary*)params
{
    NSString *path = [NSString stringWithFormat:@"/v2/book/%@/annotations", bid];
    return [[DOUQuery alloc] initWithSubPath:path parameters:nil];
}

+ (id)queryForCollectionById:(NSString*)bid
{
    NSString *path = [NSString stringWithFormat:@"/v2/book/%@/collection", bid];
    return [[DOUQuery alloc] initWithSubPath:path parameters:nil];
}

@end
