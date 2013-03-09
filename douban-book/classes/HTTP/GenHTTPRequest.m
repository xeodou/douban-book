//
//  GenHTTPRequest.m
//  douban-book
//
//  Created by xeodou on 13-1-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "GenHTTPRequest.h"
#import "DOUService.h"
#import "Constants.h"
#import "DOUBook.h"
#import "DOUQuery.h"
#import "Dou"

@interface GenHTTPRequest()

@property (nonatomic, strong) DOUService* service;
@end


@implementation GenHTTPRequest
@synthesize service;

- (DOUService*) genDOUService
{
    if(service != nil)
        return service;
    service = [DOUService sharedInstance];
    service.clientId = appkey;
    service.clientSecret = appsecret;
    return service;
}

+ (DOUBook*) getDoubanBook:(NSString*)query
{
    DOUQuery *douQuery = []
}

@end
