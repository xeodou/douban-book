//
//  BookListCell.m
//  douban-book
//
//  Created by xeodou on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookListCell.h"

@interface BookListCell()

@property (nonatomic) CGFloat offsetY;
@end

@implementation BookListCell
@synthesize image, title, price, author, publisher, rateView, readStatus;
@synthesize offsetY;
@synthesize view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) awakeFromNib
{
    offsetY = 0.0;
    [title setText:nil];
    [price setText:nil];
    [author setText:nil];
    [publisher setText:nil];
    [readStatus setText:nil];
}

- (void) setOffSet:(CGFloat) y
{
    self.offsetY = y;
}

- (void) reloadViews
{
    self.offsetY = 0.0;
    [view addSubview:title];
    [view addSubview:author];
    CGRect frame = author.frame;
    if([author text] == nil || [[author text] isEqual:@""]){
        offsetY = frame.size.height;
        [author removeFromSuperview];
    }
    [view addSubview:publisher];
    frame = publisher.frame;
    if([publisher text] == nil || [[publisher text] isEqual:@""]){
        offsetY += frame.size.height;
        [publisher removeFromSuperview];
    } else {
        frame.origin.y = frame.origin.y - offsetY;
        [publisher setFrame:frame];
    }
    frame = price.frame;
    [view addSubview:price];
    if([price text] == nil || [[price text] isEqual:@""]){
        offsetY += frame.size.height;
        [publisher removeFromSuperview];
    } else {
        frame.origin.y = frame.origin.y - offsetY;
        [price setFrame:frame];
    }
    frame = rateView.frame;
    [view addSubview:rateView];
//    if(offsetY != 0 ){
//        frame.origin.y = frame.origin.y -  offsetY;
//        [rateView setFrame:frame];
//    }
    [view addSubview:readStatus];
    if([readStatus text] == nil || [[readStatus text] isEqual:@""]){
        [readStatus setHidden:YES];
    }
    self.offsetY = 0.0;
    [self addSubview:view];
}

-(void)dealloc
{
    [self setView:nil];
    [self setImage:nil];
    [self setTitle:nil];
    [self setPrice:nil];
    [self setAuthor:nil];
    [self setPublisher:nil];
    [self setRateView:nil];
    [self setReadStatus:nil];
}

@end
