//
//  HistoryDB.h
//  douban-book
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryDB : NSObject

- (BOOL) insertHistory:(NSString*)str;
- (NSString*) searchKey:(NSString*)str;
- (BOOL)delete:(NSString*)str;
- (void)close;
- (NSArray*) getAllHistory;
- (BOOL)deleteString:(NSString*)str;
@end
