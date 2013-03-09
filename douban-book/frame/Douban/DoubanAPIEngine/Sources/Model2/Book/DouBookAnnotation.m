//
//  DouBookAnnotation.m
//  DoubanAPIEngine
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "DouBookAnnotation.h"

@implementation DouBookAnnotation
@dynamic identifer;
@dynamic bookId;
@dynamic book;
@dynamic authorId;
@dynamic author;
@dynamic chapter;
@dynamic pageNo;
@dynamic privacy;
@dynamic abstract;
@dynamic content;
@dynamic abstactPhoto;
@dynamic photos;
@dynamic lastPhoto;
@dynamic commentsCount;
@dynamic hashMath;
@dynamic time;

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

- (NSString*)authorId
{
    return [self.dictionary objectForKey:@"author_id"];
}

- (DOUUser*)author
{
    return [[DOUUser alloc] initWithDictionary:[self.dictionary objectForKey:@"author_user"]];
}

- (NSString*)chapter
{
    return [self.dictionary objectForKey:@"chapter"];
}

- (int)pageNo
{
    return [[self.dictionary objectForKey:@"page_no"] intValue];
}

- (int)privacy
{
    return [[self.dictionary objectForKey:@"privacy"] intValue];
}

- (NSString*)abstract
{
    return [self.dictionary objectForKey:@"abstract"];
}

- (NSString*)content
{
    return [self.dictionary objectForKey:@"content"];
}

- (NSString*)abstactPhoto
{
    return [self.dictionary objectForKey:@"abstract_photo"];
}

- (NSArray*)photos
{
    return [NSArray arrayWithArray:[self.dictionary objectForKey:@"photos"]];
}

- (int)lastPhoto
{
    return [[self.dictionary objectForKey:@"last_photo"] intValue];
}

- (int)commentsCount
{
    return [[self.dictionary objectForKey:@"comments_count"] intValue];
}

- (BOOL) hashMath
{
    return [[self.dictionary objectForKey:@"hasmath"] boolValue];
}

- (NSString*)time
{
    return [self.dictionary objectForKey:@"time"];
}


@end
