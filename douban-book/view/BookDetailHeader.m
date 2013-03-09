//
//  BookDetailHeader.m
//  douban-book
//
//  Created by xeodou on 13-1-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookDetailHeader.h"

@interface BookDetailHeader()

@property (nonatomic) CGFloat offsetY;
@end

@implementation BookDetailHeader
@synthesize author, average, pulisher, pages, price, pulishDate, originTitle, ISBN, image, translator;
@synthesize offsetY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    [author setText:nil];
    [average setText:nil];
    [pulishDate setText:nil];
    [pages setText:nil];
    [price setText:nil];
    [pulishDate setText:nil];
    [pulisher setText:nil];
    [originTitle setText:nil];
    [ISBN setText:nil];
    [translator setText:nil];
    offsetY = 0;
}

- (void) reloadViews
{
    if ([originTitle text] == nil || [[originTitle text] isEqual:@""]) {
        offsetY = [[originTitle superview] frame].size.height;
        [[originTitle superview] removeFromSuperview];
    }
    CGRect frame = [[author superview] frame];
    frame.origin.y = frame.origin.y - offsetY;
    [[author superview] setFrame:frame];
    if ([translator text] == nil || [[translator text] isEqual:@""]){
        offsetY = [[translator superview] frame].size.height + offsetY;
        [[translator superview] removeFromSuperview];
    } else {
        frame = [[translator superview] frame];
        frame.origin.y = frame.origin.y - offsetY;
        [[translator superview] setFrame:frame];
    }
    if ([pulisher text] == nil || [[pulisher text] isEqual:@""]){
        offsetY = [[pulisher superview] frame].size.height + offsetY;
        [[pulisher superview] removeFromSuperview];
    } else {
        frame = [[pulisher superview] frame];
        frame.origin.y = frame.origin.y - offsetY;
        [[pulisher superview] setFrame:frame];
    }
    
    if ([pulishDate text] == nil || [[pulishDate text] isEqual:@""]){
        offsetY = [[pulishDate superview] frame].size.height + offsetY;
        [[pulishDate superview] removeFromSuperview];
    } else {
        frame = [[pulishDate superview] frame];
        frame.origin.y = frame.origin.y - offsetY;
        [[pulishDate superview] setFrame:frame];
    }
    
    if ([pages text] == nil || [[pages text] isEqual:@""]){
        offsetY = [[pages superview] frame].size.height + offsetY;
        [[pages superview] removeFromSuperview];
    } else {
        frame = [[pages superview] frame];
        frame.origin.y = frame.origin.y - offsetY;
        [[pages superview] setFrame:frame];
    }
    
    if ([price text] == nil || [[price text] isEqual:@""]){
        offsetY = [[price superview] frame].size.height + offsetY;
        [[price superview] removeFromSuperview];
    } else {
        frame = [[price superview] frame];
        frame.origin.y = frame.origin.y - offsetY;
        [[price superview] setFrame:frame];
    }
    frame = [[ISBN superview] frame];
    frame.origin.y = frame.origin.y - offsetY;
    [[ISBN superview] setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) dealloc
{
    [self setAuthor:nil];
    [self setPages:nil];
    [self setPrice:nil];
    [self setPulishDate:nil];
    [self setPulisher:nil];
    [self setAverage:nil];
    [self setISBN:nil];
    [self setImage:nil];
    [self setTranslator:nil];
    [self setOriginTitle:nil];
}

@end
