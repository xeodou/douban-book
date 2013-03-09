//
//  DOUBookAnnotationArray.m
//  DoubanAPIEngine
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "DOUBookAnnotationArray.h"
#import "DouBookAnnotation.h"

@implementation DOUBookAnnotationArray

+ (Class)objectClass {
    return [DouBookAnnotation class];
}

+ (NSString *)objectName {
    return @"annotations";
}

@end
