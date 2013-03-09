//
//  DOUBook.h
//  DoubanAPIEngine
//
//  Created by Panglv on 12/5/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUObject.h"

@interface DOUBook : DOUObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *ISBN10;
@property (nonatomic, copy) NSString *ISBN13;
@property (nonatomic, copy) NSString *binding;
@property (nonatomic, copy) NSString *originTitle;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *average;

@property (nonatomic, copy) NSString *translatorStr;
@property (nonatomic, retain) NSArray *translator;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *publishDateStr;
@property (nonatomic, retain) NSDate *publishDate;

@property (nonatomic, copy) NSString *largeImage;
@property (nonatomic, copy) NSString *smallImage;
@property (nonatomic, copy) NSString *mediumImage;

@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *authorStr;
@property (nonatomic, retain) NSArray *author;
@property (nonatomic, copy) NSString *authorIntro;
@property (nonatomic, copy) NSString *summary;

@end
