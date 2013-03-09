//
//  DOUBookCollection.h
//  DoubanAPIEngine
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "DOUObject.h"
#import "DOUBook.h"

@interface DOUBookCollection : DOUObject

@property (nonatomic, copy) NSString *identifer;
@property (nonatomic, strong) DOUBook *book;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, strong) NSArray *rating;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *updated;
@property (nonatomic, copy) NSString *userId;

@end
