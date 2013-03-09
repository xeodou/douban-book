//
//  SearchViewController.m
//  douban-book
//
//  Created by xeodou on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "BookResultViewController.h"
#import "HistoryDB.h"
#import "MobClick.h"

@interface SearchViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation SearchViewController
@synthesize mTextField;
@synthesize mTableView;
@synthesize keyboardbtn;
@synthesize array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"搜索"];
    [mTextField setDelegate:self];
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    [keyboardbtn setHidden:YES];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
    
//    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadHistory];
    [MobClick beginLogPageView:@"searchviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"searchviewcontroller"];
}  

- (void)loadHistory
{
    [array removeAllObjects];
    HistoryDB *db = [[HistoryDB alloc] init];
    array = [NSMutableArray arrayWithArray:[db getAllHistory]];
    [db close];
    [mTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCellCell *cell = (HistoryCellCell*)[tableView dequeueReusableCellWithIdentifier:@"historycell"];
    if ([array count] > 0) {
        cell.delegate = self;
        [cell.name setText:[array objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(void)dismissKeyboard {
    [mTextField resignFirstResponder];
    [keyboardbtn setHidden:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [keyboardbtn setHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField text] == nil || [[textField text] isEqual:@""]){
        return NO;
    }
    HistoryDB *db = [[HistoryDB alloc] init];
    [db insertHistory:[textField text]];
    [db close];
    [self performSegueWithIdentifier:@"searchresultsugue" sender:self];
    [self dismissKeyboard];
    return YES;
}

- (void)click:(NSString *)name
{
    HistoryDB *db = [[HistoryDB alloc] init];
    [db deleteString:name];
    [db close];
    [array removeObject:name];
    [mTableView reloadData];
}

- (void)toSearch:(NSString *)name
{
    [mTextField setText:name];
    [self performSegueWithIdentifier:@"searchresultsugue" sender:self];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[BookResultViewController class]]){
        BookResultViewController *fc = (BookResultViewController*)segue.destinationViewController;
        fc.keyword = [mTextField text];
    }
}

- (void)viewDidUnload
{
    [self setMTextField:nil];
    [self setMTableView:nil];
    [self setArray:nil];
    [self setKeyboardbtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)hiddenKeyboard:(id)sender {
    [self dismissKeyboard];
}
@end
