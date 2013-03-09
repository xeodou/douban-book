//
//  UtilHelper.h
//  douban-book
//
//  Created by xeodou on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilHelper : NSObject

+ (NSString*)regMatcher:(NSString*)string regex:(NSString*)reg rangeIndex:(NSInteger)index;
+ (BOOL)isLogin;
@end
