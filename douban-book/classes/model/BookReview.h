//
//  BookReview.h
//  douban-book
//
//  Created by xeodou on 12-12-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Base.h"
#import "DoubanUser.h"
#import "DoubanBook.h"
#import "Rate.h"

@interface BookReview : Base

@property (nonatomic, strong) NSString* mstrAlt;
@property (nonatomic, strong) DoubanUser* muDoubanUser;
@property (nonatomic, strong) DoubanBook* mbBook;
@property (nonatomic, strong) Rate* mrRating;
@property (nonatomic) long mlVotes;
@property (nonatomic) long mlUseless;
@property (nonatomic) long mlComments;
@property (nonatomic, strong) NSString* mstrSummary;
@property (nonatomic, strong) NSString* mstrPublished;
@property (nonatomic, strong) NSString* mstrUpdated;
@end
