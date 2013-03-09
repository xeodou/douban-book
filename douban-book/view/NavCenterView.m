//
//  NavCenterView.m
//  douban-book
//
//  Created by xeodou on 13-1-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NavCenterView.h"

@implementation NavCenterView
@synthesize lable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setTitle:(NSString *)title
{
    if(lable != nil){
        [lable setText:title];
    }
}

- (void)dealloc
{
    [self setLable:nil];
}

@end
