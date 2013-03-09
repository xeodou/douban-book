//
//  DropDownView.m
//  douban-book
//
//  Created by xeodou on 13-1-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DropDownView.h"

@interface DropDownView(){
    BOOL mbIsShow;
}

@property (nonatomic, strong) NSMutableArray *marrDrop;
@property (nonatomic, strong) UITableView *mtable;
@property (nonatomic, strong) UILabel *mlabel;

@end


@implementation DropDownView
@synthesize marrDrop;
@synthesize mtable;
@synthesize mlabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initData:@"test"];
}

- (id) init
{
    self = [super init];
    if(self){
        [self initData:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData:title];
 
    }
    return self;
}

- (void)initData:(NSString*)title
{
    //add lable
    mlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
    [mlabel setTextColor:[UIColor whiteColor]];
    [mlabel setFont:[UIFont boldSystemFontOfSize:24.0]];
    [mlabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [mlabel setBackgroundColor:[UIColor clearColor]];
    [mlabel setTextAlignment:UITextAlignmentCenter];
    [mtable setDelegate:self];
    [mtable setDataSource:self];
    if(title != nil){
        [mlabel setText:title];
    }
    [self addSubview:mlabel];
    // add drop table
    mtable = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 200) style:UITableViewStylePlain];
    marrDrop = [[NSMutableArray alloc] initWithObjects:@"虚构", @"非虚构",nil];
    mbIsShow = NO;
    [mtable setHidden:NO];
    [self addSubview:mtable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrDrop count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void) openDrop
{
    if(mbIsShow){
        return;
    }
    mbIsShow = NO;
}

- (void) closeDrop
{
    if(!mbIsShow){
        return;
    }
    mbIsShow = YES;
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
