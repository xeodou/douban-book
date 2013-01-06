//
//  Collection.h
//  douban-book
//
//  Created by xeodou on 12-12-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Base.h"
#import "DoubanBook.h"
#import "Rate.h"

@interface Collection : Base

@property (nonatomic, strong) DoubanBook* mbBook;
@property (nonatomic, strong) NSString* mstrComment;
@property (nonatomic, strong) NSString* mstrBook_id;
@property (nonatomic, strong) Rate* mrRating;
@property (nonatomic, strong) NSString* mstrStatus;
@property (nonatomic, strong) NSArray* marrTags;
@property (nonatomic, strong) NSString* mstrUpdated;
@property (nonatomic, strong) NSString* mstrUser_id;
@end
