//
//  DOUBookCollectionArray.m
//  DoubanAPIEngine
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "DOUBookCollectionArray.h"
#import "DOUBookCollection.h"

@implementation DOUBookCollectionArray

+ (Class)objectClass {
    return [DOUBookCollection class];
}

+ (NSString *)objectName {
    return @"collections";
}

@end
