//
//  DBHelper.h
//  douban-book
//
//  Created by xeodou on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHelper : NSObject

+ (NSString*) getDBPath;
+ (void) createTable;

@end
