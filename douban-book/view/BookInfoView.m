//
//  BookInfoView.m
//  douban-book
//
//  Created by xeodou on 13-1-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookInfoView.h"

@implementation BookInfoView
@synthesize title;
@synthesize content;

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

- (void)setContentText:(NSString *)str
{
    [content setText:str];
    CGRect frame = content.frame;
    CGSize labelsize = [str sizeWithFont:content.font];
    frame.size.height = labelsize.height * (labelsize.width / 270 + 2);
    content.frame = frame;
    CGFloat h = frame.origin.y + frame.size.height + 4;
    frame = self.frame;
    [self setFrame:CGRectMake(0, 0, 300, h)];
}

@end
