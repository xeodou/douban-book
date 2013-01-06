//
//  DoubanUser.h
//  douban-book
//
//  Created by xeodou on 12-12-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface DoubanUser : User

@property (nonatomic, strong) NSString* mstrRelation;
@property (nonatomic, strong) NSString* mstrCreated;
@property (nonatomic) long mstrLocid;
@property (nonatomic, strong) NSString* mstrLocname;
@property (nonatomic, strong) NSString* mstrDesc;
@end
