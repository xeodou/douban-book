//
//  DropedView.m
//  douban-book
//
//  Created by xeodou on 13-1-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DropedView.h"

@interface DropedView()

@property (nonatomic, strong) NSMutableArray *marray;
@end

@implementation DropedView
@synthesize marray;
@synthesize mtable;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    marray = [[NSMutableArray alloc] initWithObjects:@"虚构",@"非虚构", nil];
    [mtable setDataSource:self];
    [mtable setDelegate:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    [cell.textLabel setText:[marray objectAtIndex:indexPath.row]];
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(delegate != nil){
        [[self delegate] dropviewitemClick:indexPath.row];
    }
}

- (void) setDataArray:(NSArray *)array
{
    if(array != nil){
        [marray removeAllObjects];
        marray = [NSMutableArray arrayWithArray:array];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [self setMarray:nil];
    [self setMtable:nil];
}

@end
