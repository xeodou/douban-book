//
//  BookResultViewController.m
//  douban-book
//
//  Created by xeodou on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookResultViewController.h"
#import "BookListCell.h"
#import "DouQueryBook.h"
#import "GenDouService.h"
#import "MBProgressHUD.h"
#import "GenDouService.h"
#import "DouQueryBook.h"
#import "DOUAPIEngine.h"
#import "DOUBookArray.h"
#import "DOUBook.h"
#import "BookDetailViewController.h"
#import "FirstViewController.h"
#import "DOUBookCollectionArray.h"
#import "DOUBookCollection.h"
#import "UIHelper.h"
#import "MobClick.h"

@interface BookResultViewController ()

@property (nonatomic,strong) NSMutableArray *bookArray;
@property (nonatomic, assign) int selectItem;
@property (nonatomic, assign) int mnStart;
@property (nonatomic, assign) BOOL isAll;
@end

@implementation BookResultViewController
@synthesize mTableView;
@synthesize bookArray;
@synthesize keyword;
@synthesize tag;
@synthesize selectItem;
@synthesize status;
@synthesize uid;
@synthesize mnStart;
@synthesize isAll;

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
    if(keyword != nil){
        [self.navigationItem setTitle: keyword];
    } else {
        [self.navigationItem setTitle:tag];
    }
    [self initData];
}

- (void)initData 
{
    selectItem = 0;
    mnStart = 0;
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    bookArray = [[NSMutableArray alloc] init];
    if (_loadMoreFooterView == nil) {		
		LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.mTableView.contentSize.height, self.mTableView.frame.size.width, self.mTableView.bounds.size.height)];
		view.delegate = self;
		[self.mTableView addSubview:view];
		_loadMoreFooterView = view;
		
	}
	[self loadRequest];
}

- (void) loadRequest
{
    if (isAll) {
        [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_book_all", nil)];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    if(keyword == nil && tag == nil && status == nil){
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"hud_info_search", nil);
    } else {
        [self genDouQuery:hud keyword:keyword tag:tag start:mnStart count:20];
    }
}

- (void) genDouQuery:(MBProgressHUD*)hud keyword:(NSString*)k tag:(NSString*)t start:(NSInteger)start count:(NSInteger)count
{
    DOUService *service = [[[GenDouService alloc] init] genDouService]; 
    service.apiBaseUrlString = kHttpsApiBaseUrl;
    DOUQuery *query = nil;
    if (status != nil) {
        query = [DouQueryBook queryForBookByCollection:uid status:status start:start count:count];
    } else {
        query = [DouQueryBook queryForBookBykey:k tag:t start:start count:count];
    }
    DOUReqBlock block = ^(DOUHttpRequest *req){
        //            NSLog(@"%@", [req responseString]);
        NSError *error = [req doubanError];
        if(!error){
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"Completed";
            if (status != nil) {
                DOUBookCollectionArray *result = [[DOUBookCollectionArray alloc] initWithString:[req responseString]];
                if ([[result objectArray] count] < 20) {
                    isAll = YES;
                }
                if (result != nil) {
                    for ( DOUBookCollection *c in [result objectArray]) {
                        [bookArray addObject:c.book];
                    }
                }
                
            } else {
                DOUBookArray *result = [[DOUBookArray alloc] initWithString:[req responseString]];
                if ([[result objectArray] count] < 20) {
                    isAll = YES;
                }
                [bookArray addObjectsFromArray:[result objectArray]];
            }
            if ([bookArray count] <= 0) {
                [self showAlert:NSLocalizedString(@"alert_msg_book_error", nil)];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self updateUI];
        } else {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = NSLocalizedString(@"hud_info_result", nil);
            [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1.0];
            return ;
        }
    };
    [service get:query callback:block];
}

- (void)dismissHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) showAlert:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title_info", nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"alert_btn_cancel", nil) otherButtonTitles:NSLocalizedString(@"alert_btn_retry", nil), nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loadRequest];
    }
}

- (void) updateUI
{
    [mTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"bookresultviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"bookresultviewcontroller"];
}  

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self setMTableView:nil];
    [self setBookArray:nil];
    [self setStatus:nil];
    [self setKeyword:nil];
    [self setUid:nil];
    [self setTag:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [bookArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookListCell *cell = (BookListCell*)[tableView dequeueReusableCellWithIdentifier:@"BookListCell"];
    if(bookArray != nil && [bookArray count] > 0){
        DOUBook *book = (DOUBook*)[bookArray objectAtIndex:indexPath.row];
        [cell.image setImageWithURL:[NSURL URLWithString:[book mediumImage]]];
        [cell.title setText:[book title]];
        [cell.author setText:[[book author] componentsJoinedByString:@" "]];
        [cell.publisher setText:[book publisher]];
        [cell.price setText:[book price]];
        [cell.rateView reloadViews:[[book average] floatValue]];
//        [cell setOffSet:0.0f];
//        [cell reloadViews];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(bookArray != nil && [bookArray count] > 0){
        selectItem = indexPath.row;
        [self performSegueWithIdentifier:@"resultToDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[BookDetailViewController class]]){
        BookDetailViewController *fc = (BookDetailViewController*)[segue destinationViewController];
        fc.mdouBook = [bookArray objectAtIndex:selectItem];
//        [fc.navigationItem title:nil];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];		
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view {
    
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    
}


- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view {
	return _reloading;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
    mnStart += 20;
    [self loadRequest];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.mTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 131.0f;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
