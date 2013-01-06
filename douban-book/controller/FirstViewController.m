//
//  FirstViewController.m
//  douban-book
//
//  Created by xeodou on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "CustomGridCell.h"
#import "TFHpple.h"
#import "ASIHTTPRequest.h"

@interface FirstViewController ()
@property (nonatomic, strong) NSMutableArray* marrTotal;
@end

@implementation FirstViewController
@synthesize mTableView;
@synthesize mDropDownView;
@synthesize marrTotal;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initData];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://book.douban.com/latest"]];
    [request setCachePolicy:ASIUseDefaultCachePolicy];
    [request startSynchronous];
    NSError *error = [request error];

    NSData *data = [request responseData];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='article']/ul/li"];
//    TFHppleElement *elemnt = [elements objectAtIndex:0];
    for (TFHppleElement *element in elements) {
        if(element != nil){
//            NSLog(@"%@", [element description]);
            NSArray *arr = [element children];
            if([arr count] > 0){
                TFHppleElement *el = (TFHppleElement*)[arr objectAtIndex:3];
                NSArray *arrChild = [el children];
                if([arrChild count] > 0){
                    NSString *str = [[arrChild objectAtIndex:0] objectForKey:@"src"];
//                    NSLog(@"%@", str);
                    if(str != nil){
                        [marrTotal addObject:str];
                    }
                }
            }
        }
    }
    
}

- (void) initData 
{    
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    marrTotal = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStyleBordered target:self action:nil];
    [[self.parentViewController navigationItem] setLeftBarButtonItem:item];
    item = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStyleBordered target:self action:nil];
    [self.parentViewController.navigationItem setRightBarButtonItem:item];
    [self.parentViewController.navigationItem setTitleView:nil];
    [self.parentViewController.navigationItem setTitleView:mDropDownView];
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [self setMDropDownView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrTotal count] % 3 == 0 ? [marrTotal count] / 3 : [marrTotal count] / 3 + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomGridCell *tableCell = (CustomGridCell*)[tableView dequeueReusableCellWithIdentifier:@"BookGridCell"];
    NSLog(@"%@",[NSString stringWithFormat:@"%@", [marrTotal objectAtIndex:indexPath.row * 3 + 0]]);
    if(indexPath.row * 3 < [marrTotal count]){
        [tableCell.grid_first_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [marrTotal objectAtIndex:indexPath.row * 3 + 0]]]];
    }
    if(indexPath.row * 3 + 1 < [marrTotal count]){
        [tableCell.grid_second_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [marrTotal objectAtIndex:indexPath.row * 3 + 1]]]];
    }
    if(indexPath.row * 3 + 2 < [marrTotal count]){
        [tableCell.grid_third_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [marrTotal objectAtIndex:indexPath.row * 3 + 2]]]];
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0f;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
