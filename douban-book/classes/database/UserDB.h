//
//  UserDB.h
//  douban-book
//
//  Created by xeodou on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DOUUser.h"

@interface UserDB : NSObject

- (BOOL)insertUser:(DOUUser*)user;
- (void)close;
- (DOUUser*) getUser;
- (BOOL)deleteUser;
@end
