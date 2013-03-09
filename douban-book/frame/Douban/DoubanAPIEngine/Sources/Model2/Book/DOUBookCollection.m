//
//  DOUBookCollection.m
//  DoubanAPIEngine
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "DOUBookCollection.h"

@implementation DOUBookCollection

@dynamic identifer;
@dynamic book;
@dynamic bookId;
@dynamic comment;
@dynamic rating;
@dynamic status;
@dynamic tags;
@dynamic updated;
@dynamic userId;


- (NSString*)identifer
{
    return [self.dictionary objectForKey:@"id"];
}

- (NSString*)bookId
{
    return [self.dictionary objectForKey:@"book_id"];
}

- (DOUBook*)book
{
    return [[DOUBook alloc] initWithDictionary:[self.dictionary objectForKey:@"book"]];
}

- (NSString*)comment
{
    return [self.dictionary objectForKey:@"comment"];
}

- (NSArray*)rating
{
    return [NSArray arrayWithArray:[self.dictionary objectForKey:@"rating"]];
}

- (NSString*)status
{
    return [self.dictionary objectForKey:@"status"];
}

- (NSArray*)tags
{
    return [NSArray arrayWithArray:[self.dictionary objectForKey:@"tags"]];
}

- (NSString*)updated
{
    return [self.dictionary objectForKey:@"updated"];
}

- (NSString*)userId
{
    return [self.dictionary objectForKey:@"user_id"];
}

@end
