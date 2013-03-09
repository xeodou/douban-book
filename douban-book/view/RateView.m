//
//  RateView.m
//  douban-book
//
//  Created by xeodou on 13-2-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RateView.h"

@interface RateView()

@property (nonatomic,assign) int select;
@end

@implementation RateView
@synthesize oneStar,twoStar, threeStar, fourStar, fiveStar, select;

- (void)awakeFromNib
{
    [oneStar setTag:0x0001];
    [twoStar setTag:0x0002];
    [threeStar setTag:0x0003];
    [fourStar setTag:0x0004];
    [fiveStar setTag:0x0005];
    select = 0;

}


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

- (IBAction)click:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 1) {
        [oneStar setSelected:YES];
        [twoStar setSelected:NO];
        [threeStar setSelected:NO];
        [fourStar setSelected:NO];
        [fiveStar setSelected:NO];
        select = 1;
    } else if (btn.tag == 2) {
        [oneStar setSelected:YES];
        [twoStar setSelected:YES];
        [threeStar setSelected:NO];
        [fourStar setSelected:NO];
        [fiveStar setSelected:NO];
        select = 2;
    } else if (btn.tag == 3) {
        [oneStar setSelected:YES];
        [twoStar setSelected:YES];
        [threeStar setSelected:YES];
        [fourStar setSelected:NO];
        [fiveStar setSelected:NO];
        select = 3;
    } else if ( btn.tag == 4) {
        [oneStar setSelected:YES];
        [twoStar setSelected:YES];
        [threeStar setSelected:YES];
        [fourStar setSelected:YES];
        [fiveStar setSelected:NO];
        select = 4;
    } else if (btn.tag == 5) {
        [oneStar setSelected:YES];
        [twoStar setSelected:YES];
        [threeStar setSelected:YES];
        [fourStar setSelected:YES];
        [fiveStar setSelected:YES];
        select = 5;
    }
}

- (int)rate
{
    return select;
}

- (void)dealloc
{
    [self setOneStar:nil];
    [self setTwoStar:nil];
    [self setThreeStar:nil];
    [self setFourStar:nil];
    [self setFiveStar:nil];
}

@end
