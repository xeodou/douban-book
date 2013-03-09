//
//  MyReadCell.m
//  douban-book
//
//  Created by xeodou on 13-2-1.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyReadCell.h"

@implementation MyReadCell
@synthesize label;

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
    [self setLabel:nil];
}

@end
