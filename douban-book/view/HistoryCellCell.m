//
//  HistoryCellCell.m
//  douban-book
//
//  Created by xeodou on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "HistoryCellCell.h"

@implementation HistoryCellCell
@synthesize name;
@synthesize delegate;
@synthesize delBtn;

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

- (void)dealloc
{
    [self setDelegate:nil];
    [self setName:nil];
    [self setDelBtn:nil];
}


- (IBAction)deleteClick:(id)sender
{
    if (delegate) {
        [[self delegate] click:name.text];
    }
}

- (IBAction)contentClick:(id)sender
{
    if (delegate) {
        [[self delegate] toSearch:name.text];
    }
}

@end
