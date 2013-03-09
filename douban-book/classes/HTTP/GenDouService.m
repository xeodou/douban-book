//
//  GenDouService.m
//  douban-book
//
//  Created by xeodou on 13-1-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "GenDouService.h"
#import "Constants.h"

@interface GenDouService()

@property (nonatomic, strong) DOUService *service;
@end


@implementation GenDouService
@synthesize service;

- (id)init
{
    self = [super init];
    if(self){
        if(service == nil){
            service = [DOUService sharedInstance];
            service.clientId = appkey;
            service.clientSecret = appsecret;
        }
    }
    return self;
}

- (DOUService*) genDouService
{
    return service;
}

@end
