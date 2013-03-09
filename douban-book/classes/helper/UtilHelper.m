//
//  UtilHelper.m
//  douban-book
//
//  Created by xeodou on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UtilHelper.h"
#import "UserDB.h"

@implementation UtilHelper

+ (NSString*)regMatcher:(NSString *)string regex:(NSString *)reg rangeIndex:(NSInteger)index
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg options:0 error:&error];
    if(error){
        NSLog(@"%@", error);
        return nil;
    }
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    NSString *matcher = [string substringWithRange:[match rangeAtIndex:index]];
    return matcher;
}

+ (BOOL)isLogin
{
    UserDB *userDb = [[UserDB alloc] init];
    [userDb close];
    if (![userDb getUser]) {
        return NO;
    }   
    return YES;
}

@end
