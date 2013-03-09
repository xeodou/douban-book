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
@synthesize grid_first_label, grid_third_label, grid_second_label;
@synthesize grid_first_author, grid_third_author, grid_second_author;
@synthesize delegate;
@synthesize row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    row = 0;
    [grid_first_image setUserInteractionEnabled:YES];
    [grid_second_image setUserInteractionEnabled:YES];
    [grid_third_image setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstClick)];
    [grid_first_image addGestureRecognizer:singleTouch];
    singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondClick)];
    [grid_second_image addGestureRecognizer:singleTouch];
    singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdClick)];
    [grid_third_image addGestureRecognizer:singleTouch];
}

- (void) firstClick
{
    NSLog(@"one");
    [self click:1];
}

- (void) secondClick
{
    NSLog(@"two");
    [self click:2];
}

- (void) thirdClick
{
    NSLog(@"three");
    [self click:3];
}

- (void)click:(NSInteger)index
{
    if (delegate != nil) {
        [[self delegate] gridCellItemClick:index row:row];
    }
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
    [self setGrid_first_label:nil];
    [self setGrid_second_label:nil];
    [self setGrid_third_label:nil];
    [self setGrid_first_author:nil];
    [self setGrid_second_author:nil];
    [self setGrid_third_author:nil];
    [self setDelegate:nil];
}

@end
