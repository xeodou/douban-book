//
//  Rate.h
//  douban-book
//
//  Created by xeodou on 12-12-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Base.h"

@interface Rate : Base

@property (nonatomic) NSInteger mnMax;
@property (nonatomic) long mlNumRaters;
@property (nonatomic, strong) NSString* mstrAverage;
@property (nonatomic) NSInteger mnMin;
@end
