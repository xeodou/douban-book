//
//  DouBookAnnotation.h
//  DoubanAPIEngine
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "DOUObject.h"
#import "DOUUser.h"
#import "DOUBook.h"

@interface DouBookAnnotation : DOUObject

@property (nonatomic, copy) NSString *identifer;
@property (nonatomic, strong) DOUBook *book;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *authorId;
@property (nonatomic, strong) DOUUser *author;
@property (nonatomic, copy) NSString *chapter;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int privacy;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *abstactPhoto;
@property (nonatomic, strong)NSArray *photos;
@property (nonatomic, assign) int lastPhoto;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, assign) BOOL hashMath;
@property (nonatomic, copy) NSString *time;


@end
