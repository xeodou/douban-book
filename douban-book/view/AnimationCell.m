//
//  AnimationCell.m
//  douban-book
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AnimationCell.h"

@implementation AnimationCell
@synthesize image;
@synthesize name;
@synthesize title;
@synthesize page;
@synthesize abstract;
@synthesize content;
@synthesize bgview;
@synthesize delegate;
@synthesize bookId;

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
    [self setImage:nil];
    [self setName:nil];
    [self setTitle:nil];
    [self setPage:nil];
    [self setAbstract:nil];
    [self setContent:nil];
    [self setBgview:nil];
    [self setDelegate:nil];
    [self bookId];
}

- (void)setCOntentText:(NSString*)str
{
    UIFont *font = [content font];
    CGSize size = [str sizeWithFont:font];
    CGRect frame = content.frame;
    float h = (size.width / frame.size.width + 1) * size.height;
    float ofh = 0;
    if (h > frame.size.height) {
        ofh = h - frame.size.height;
    }
    frame.size = CGSizeMake(frame.size.width, h);
    [content setFrame:frame];
    [content setText:str];
    frame = bgview.frame;
    frame.size.height += ofh;
    [bgview setFrame:frame];
    if (ofh == 0) {
        ofh = bgview.frame.size.height;
    }
    frame = self.frame;
    frame.size.height += ofh;
    [self setFrame:frame];
}

- (IBAction)click:(id)sender
{
    if (delegate != nil) {
        [[self delegate] AnnotationClick:bookId];
    }
}
- (void)addView
{
    [self addSubview:bgview];
}

@end
