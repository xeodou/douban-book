//
//  BookRateView.m
//  douban-book
//
//  Created by xeodou on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookRateView.h"

@implementation BookRateView
@synthesize oneStar,twoStar, threeStar, fourStar, fiveStar, rate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) reloadViews:(float)averger
{
    [self.rate setText:[NSString stringWithFormat:@"%.1f",averger]];
    if (averger <= 10 && averger > 8) {
        [oneStar setHighlighted:YES];
        [twoStar setHighlighted:YES];
        [threeStar setHighlighted:YES];
        [fourStar setHighlighted:YES];
        [fiveStar setHighlighted:YES];
    } else if(averger <= 8 && averger > 6){
        [oneStar setHighlighted:YES];
        [twoStar setHighlighted:YES];
        [threeStar setHighlighted:YES];
        [fourStar setHighlighted:YES];
    } else if (averger <= 6 && averger > 4) {
        [oneStar setHighlighted:YES];
        [twoStar setHighlighted:YES];
        [threeStar setHighlighted:YES];
    } else if (averger <= 4 && averger > 2) {
        [oneStar setHighlighted:YES];
        [twoStar setHighlighted:YES];
    } else if (averger <= 2 && averger > 0) {
        [oneStar setHighlighted:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [self setOneStar:nil];
    [self setTwoStar:nil];
    [self setThreeStar:nil];
    [self setFourStar:nil];
    [self setFiveStar:nil];
    [self setRate:nil];
}

@end
