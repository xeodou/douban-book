//
//  DoubanBook.h
//  douban-book
//
//  Created by xeodou on 12-12-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base.h"
#import "Rate.h"

@interface DoubanBook : Base

@property (nonatomic, strong) NSString* mstrIsbn10;
@property (nonatomic, strong) NSString* mstrIsbn13;
@property (nonatomic, strong) NSString* mstrTitle;
@property (nonatomic, strong) NSString* mstrOrigin_title;
@property (nonatomic, strong) NSString* mstrAtl_title;
@property (nonatomic, strong) NSString* mstrSubtitle;
@property (nonatomic, strong) NSString* mstrUrl;
@property (nonatomic, strong) NSString* mstrAlt;
@property (nonatomic, strong) NSString* mstrImage;
@property (nonatomic, strong) NSArray* marrImages;
@property (nonatomic, strong) NSArray* marrAuthors;
@property (nonatomic, strong) NSArray* marrTranslator;
@property (nonatomic, strong) NSString* mstrPublisher;
@property (nonatomic, strong) NSString* mstrPubdate;
@property (nonatomic, strong) Rate* mrRating;
@property (nonatomic, strong) NSArray* marrTags;
@property (nonatomic, strong) NSString* mstrBinding;
@property (nonatomic, strong) NSString* mstrPrice;
@property (nonatomic, strong) NSString* mstrPages;
@property (nonatomic, strong) NSString* mstrAuthor_intro;
@property (nonatomic, strong) NSString* mstrSummary;
@end
