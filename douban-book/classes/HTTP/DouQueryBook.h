//
//  DouQueryBook.h
//  douban-book
//
//  Created by xeodou on 13-1-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUQuery.h"

@interface DouQueryBook : DOUQuery

+ (id)queryForBookById:(NSString*)bookId;
+ (id)queryForBookByIsbn:(NSString*)isbn;
+ (id)queryForBookBykey:(NSString*)key tag:(NSString*)tag start:(NSInteger)start count:(NSInteger)count;
+ (id)queryForBookByCollection:(NSString*)uid status:(NSString*)status start:(NSInteger)start count:(NSInteger)count;
+ (id) queryForAnnotationByName:(NSString*)uid start:(NSInteger)start count:(NSInteger)count;
+ (id)queryForAnnotaionByBookId:(NSString*)bid start:(NSInteger)start count:(NSInteger)count;
+ (id)addAnnotationForBook:(NSString*)bid withParams:(NSMutableDictionary*)params;
+ (id)queryForCollectionById:(NSString*)bid;
@end
