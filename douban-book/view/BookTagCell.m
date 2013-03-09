//
//  BookTagCell.m
//  douban-book
//
//  Created by xeodou on 13-1-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookTagCell.h"
#import "PrettyDrawing.h"

@implementation BookTagCell
@synthesize title;
@synthesize tagView;
@synthesize bgView;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
//    [title setText:nil];
//    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sort_tags_cell_down_bg.png"]];
    [tagView setBackgroundColor:[UIColor colorWithHex:0xedf4ed]];
//    [tagView clearsContextBeforeDrawing];
}

- (id) initWith:(NSArray*)array
{
    self = [super init];
    if (self) {
        [tagView setBackgroundColor:[UIColor colorWithHex:0xedf4ed]];
        [self setTags:array];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTags:(NSArray *)array
{
    float x = 18, y = 5, w = tagView.frame.size.width;
    for ( NSString * str in array) {
        UIFont *font = [UIFont fontWithName:@"Times New Roman" size:15.0f];
        CGSize fontSize = [str sizeWithFont:font];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, fontSize.width + 16.0, fontSize.height + 12.0)];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:font];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x5cae68] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"sort_tags_tag_bg_n.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"sort_tags_tag_bg_p.png"] forState:UIControlStateHighlighted];
        [tagView addSubview:btn];
        CGRect frame = btn.frame;
        if( w - x - 23 >= frame.size.width){
            frame.origin = CGPointMake( x , y);
            x += frame.size.width + 5;
        } else {
            y += frame.size.height + 5;
            x = 18;
            frame.origin = CGPointMake(x, y);
            x += frame.size.width + 5;
        }
        [btn setFrame:frame];
    }
    CGRect frame = tagView.frame;
    CGFloat offset = y + 38 - frame.size.height;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + offset);
    [tagView setFrame:frame];
    [bgView addSubview:tagView];
    frame = bgView.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height + offset);
    [bgView setFrame:frame];
    [self.contentView addSubview:bgView];
    frame  = self.frame;
    frame.size.height += offset;
    [self setFrame:frame];
}

- (void) click:(id)sender
{
    NSString *str = ((UIButton*)sender).titleLabel.text;
    NSLog(@"%@", str);
    [[self delegate] tagClick:str];
}

- (void)dealloc
{
    [self setDelegate:nil];
    [self setTitle:nil];
    [self setTagView:nil];
    [self setBgView:nil];
}

@end
