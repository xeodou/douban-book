//
//  DouQueryUser.m
//  douban-book
//
//  Created by xeodou on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DouQueryUser.h"

@implementation DouQueryUser

+ (DOUQuery*)querForSelf
{
//    NSString *substr = @"/v2/user/~me";
//    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:substr parameters:nil];
//    return query;
    return [[DouQueryUser class] querForUser:@"~me"];
}

+ (DOUQuery*)querForUser:(NSString *)identifer
{
    NSString *substr = [NSString stringWithFormat:@"/v2/user/%@", identifer];
    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:substr parameters:nil];
    return query;
}

@end
