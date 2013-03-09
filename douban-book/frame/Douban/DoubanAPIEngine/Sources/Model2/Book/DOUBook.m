//
//  DOUBook.m
//  DoubanAPIEngine
//
//  Created by Panglv on 12/5/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUBook.h"
#import "DOUObject+Utils.h"


@implementation DOUBook

@dynamic identifier;
@dynamic title;
@dynamic subTitle;
@dynamic rating;
@dynamic ISBN10;
@dynamic ISBN13;

@dynamic publisher;
@dynamic publishDateStr;
@dynamic publishDate;

@dynamic largeImage;
@dynamic smallImage;
@dynamic mediumImage;

@dynamic authorIntro;
@dynamic summary;
@dynamic binding;
@dynamic author;
@dynamic originTitle;
@dynamic translator;
@dynamic subtitle;
@dynamic pages;
@dynamic average;
@dynamic translatorStr;
@dynamic authorStr;
@dynamic price;


- (NSString *)identifier {
  return [self.dictionary objectForKey:@"id"];
}

- (NSString *)subTitle {
  return [self.dictionary objectForKey:@"subtitle"];
}

- (NSString *)title {
  return [self.dictionary objectForKey:@"title"];
}

- (NSString *)rating {
  return [self.dictionary objectForKey:@"rating"];
}

- (NSString *)binding {
    return [self.dictionary objectForKey:@"binding"];
}

- (NSString *)authorStr {
    return [self.dictionary objectForKey:@"author"];
}

- (NSArray *)author {
    return [NSArray arrayWithArray:[self.dictionary objectForKey:@"author"]];
}

- (NSString *)originTitle {
    return [self.dictionary objectForKey:@"origin_title"];
}

- (NSString *)translatorStr {
    return [self.dictionary objectForKey:@"translator"];
}

- (NSArray *)translator {
    return [NSArray arrayWithArray:[self.dictionary objectForKey:@"translator"]];
}

- (NSString *)pages {
    return [self.dictionary objectForKey:@"pages"];
}

- (NSString *)subtitle {
    return [self.dictionary objectForKey:@"subtitle"];
}

- (NSString *) publisher {
    return [self.dictionary objectForKey:@"publisher"];
}

- (NSString *) price {
    return [self.dictionary objectForKey:@"price"];
}

- (NSString *)numRaters {
    NSMutableDictionary *dic = [self.dictionary objectForKey:@"rating"];
    if (!dic) {
        return nil;
    } else {
        return [dic objectForKey:@"numRaters"];
    }
}

- (NSString *)average {
    NSMutableDictionary *dic = [self.dictionary objectForKey:@"rating"];
    if (!dic) {
        return nil;
    } else {
        return [dic objectForKey:@"average"];
    }
}

- (NSString *)ISBN10 {
    return [self.dictionary objectForKey:@"isbn10"];
}

- (NSString *)ISBN13 {
    return [self.dictionary objectForKey:@"isbn13"];
}

- (NSString *)publishDateStr {
    return [self.dictionary objectForKey:@"pubdate"];
}


- (NSDate *)publishDate {
    return [[self class] dateOfString:self.publishDateStr dateFormat:@"yyyy-MM"];
}


- (NSString *)images{
    return [self.dictionary objectForKey:@"images"];
}

- (NSString *)largeImage {
    NSMutableDictionary *dic = [self.dictionary objectForKey:@"images"];
    if (!dic) {
        return nil;
    } else {
        return [dic objectForKey:@"large"];
    }
}

- (NSString *)smallImage {
    NSMutableDictionary *dic = [self.dictionary objectForKey:@"images"];
    if (!dic) {
        return nil;
    } else {
        return [dic objectForKey:@"small"];
    }
}

- (NSString *)mediumImage {
    NSMutableDictionary *dic = [self.dictionary objectForKey:@"images"];
    if (!dic) {
        return nil;
    } else {
        return [dic objectForKey:@"medium"];
    }
}

- (NSString *)authorIntro {
  return [self.dictionary objectForKey:@"author_intro"];
}

- (NSString *)summary {
  return [self.dictionary objectForKey:@"summary"];
}


@end
