//
//  Annotation.h
//  douban-book
//
//  Created by xeodou on 12-12-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Base.h"
#import "DoubanBook.h"
#import "DoubanUser.h"

@interface Annotation : Base

@property (nonatomic) long mlBook_id;
@property (nonatomic, strong) DoubanBook* mbDouBook;
@property (nonatomic, strong) NSString* mstrAuthor_id;
@property (nonatomic, strong) DoubanUser* muDouUser;
@property (nonatomic, strong) NSString* mstrChapter;
@property (nonatomic) long mlpage_no;
@property (nonatomic) int mnPrivacy;
@property (nonatomic, strong) NSString* mstrAbstract;
@property (nonatomic, strong) NSString* mstrContent;
@property (nonatomic, strong) NSString* mstrAbstact_photo;
@property (nonatomic, strong) NSArray* marrPhotos;
@property (nonatomic) int mnLast_photo;
@property (nonatomic) int mnComments_count;
@property (nonatomic) BOOL mbHasmath;
@property (nonatomic, strong) NSString* mstrTime;
@end
