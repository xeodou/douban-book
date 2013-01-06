//
//  CustomGridCell.m
//  douban-book
//
//  Created by xeodou on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomGridCell.h"

@implementation CustomGridCell
@synthesize grid_first_image, grid_third_image, grid_second_image;

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

- (void) dealloc
{
    [self setGrid_first_image:nil];
    [self setGrid_second_image:nil];
    [self setGrid_third_image:nil];
}

@end
