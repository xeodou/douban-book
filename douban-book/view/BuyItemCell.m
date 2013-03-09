//
//  BuyItemCell.m
//  douban-book
//
//  Created by xeodou on 13-1-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BuyItemCell.h"

@implementation BuyItemCell
@synthesize image;
@synthesize oldPrice;
@synthesize newprice;
@synthesize url;
@synthesize delegate;
@synthesize merchant;

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

- (IBAction)buyBtnClick:(id)sender
{
    NSLog(@"%@", url);
    if (url != nil) {
        [[self delegate] buyItemCellBtnClick:url];
    }
}

- (void)dealloc
{
    [self setMerchant:nil];
    [self setDelegate:nil];
    [self setImage:nil];
    [self setNewprice:nil];
    [self setOldPrice:nil];
    [self setUrl:nil];
}

@end
