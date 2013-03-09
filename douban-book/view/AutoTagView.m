//
//  AutoTagView.m
//  douban-book
//
//  Created by xeodou on 13-1-26.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AutoTagView.h"
#import "PrettyDrawing.h"

@implementation AutoTagView
@synthesize title;
@synthesize tagsView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWith:(NSArray*)array
{
    self = [super init];
    if (self) {
        [tagsView setBackgroundColor:[UIColor colorWithHex:0xedf4ed]];
        [self setTags:array];
    }
    return self;
}

- (void) awakeFromNib
{
    //    [title setText:nil];
    //    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sort_tags_cell_down_bg.png"]];
    [tagsView setBackgroundColor:[UIColor colorWithHex:0xedf4ed]];
    //    [tagView clearsContextBeforeDrawing];
}

- (void) setTags:(NSArray *)array
{
    float x = 12, y = 5, w = 298;
    for ( NSString * str in array) {
        UIFont *font = [UIFont fontWithName:@"Times New Roman" size:15.0f];
        CGSize fontSize = [str sizeWithFont:font];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, fontSize.width + 16.0, fontSize.height + 12.0)];
        [btn.titleLabel setFont:font];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x5cae68] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"sort_tags_tag_bg_n.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"sort_tags_tag_bg_p.png"] forState:UIControlStateHighlighted];
        [tagsView addSubview:btn];
        CGRect frame = btn.frame;
        if( w - x - 17 >= frame.size.width){
            frame.origin = CGPointMake( x , y);
            x += frame.size.width + 5;
        } else {
            y += frame.size.height + 5;
            x = 12;
            frame.origin = CGPointMake(x, y);
            x += frame.size.width + 5;
        }
        [btn setFrame:frame];
    }
    CGRect frame = tagsView.frame;
    CGFloat offset = y + 38 - frame.size.height;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + offset);
    [tagsView setFrame:frame];
    frame = self.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height + offset);
    [self setFrame:frame];
//    frame  = self.frame;
//    frame.size.height += offset;
//    [self addSubview:bgView];
//    [self setFrame:frame];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
