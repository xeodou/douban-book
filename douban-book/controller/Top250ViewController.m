//
//  Top250ViewController.m
//  douban-book
//
//  Created by xeodou on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Top250ViewController.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "TFHpple.h"
#import "BookDetailViewController.h"
#import "DOUBook.h"
#import "MobClick.h"
#import "ASIDownloadCache.h"


@interface Top250ViewController ()

@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) int start;
@property (nonatomic, strong) NSDictionary *bookId;
@end

@implementation Top250ViewController
@synthesize mTableView;
@synthesize totalArray;
@synthesize hud;
@synthesize start;
@synthesize bookId;

NSString * const bId = @"bookId";
NSString * const bImage = @"bookImage";
NSString * const bName = @"bookName";

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
    [self.navigationItem setTitle:@"TOP250"];
    [self initData];
    [self loadRequest];
}

- (void) initData
{
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    totalArray = [[NSMutableArray alloc] init];
    start = 0;
    if (_loadMoreFooterView == nil) {		
		LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.mTableView.contentSize.height, self.mTableView.frame.size.width, self.mTableView.bounds.size.height)];
		view.delegate = self;
		[self.mTableView addSubview:view];
		_loadMoreFooterView = view;
		
	}	
}


- (void) loadRequest
{
    if (start >= 250) {
        [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_top250_all", nil)];
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://book.douban.com/top250?start=%d",start]]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [[ ASIDownloadCache sharedCache ] setShouldRespectCacheControlHeaders:NO ];
    [request setSecondsToCache:60*60*24*7];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlert:NSLocalizedString(@"alert_msg_top250", nil)];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
    [self loadTOP250Data:[request responseData]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([totalArray count] <= 0) {
        [self showAlert:NSLocalizedString(@"alert_msg_top250", nil)];
    }
    [mTableView reloadData];
}

- (void) loadTOP250Data:(NSData*)data
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='indent']//tr"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TFHppleElement *elment in elements) {
        NSArray *childs = [elment children];
        if ([childs count] > 0) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            childs = [elment childrenWithTagName:@"td"];
            if ([childs count] > 1) {
                TFHppleElement *el = [childs objectAtIndex:0];
                el = [el firstChildWithTagName:@"a"];
                NSString *str = [[el attributes] objectForKey:@"href"];
                str = [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
                [dic setObject:str forKey:bId];
                el = [el firstChildWithTagName:@"img"];
                str = [[el attributes] objectForKey:@"src"];
                [dic setObject:str forKey:bImage];
            }
            if([childs count] >= 2){
                TFHppleElement *el = [childs objectAtIndex:1];
                el = [el firstChildWithTagName:@"div"];
                el = [el firstChildWithTagName:@"a"];
                NSString *str = [[el attributes] objectForKey:@"title"];
                [dic setObject:str forKey:bName];
            }
            [array addObject:dic];
        }
    }
    [totalArray addObjectsFromArray:array];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [totalArray count] % 3 == 0 ? [totalArray count] / 3 : [totalArray count] / 3 + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomGridCell *tableCell = (CustomGridCell*)[tableView dequeueReusableCellWithIdentifier:@"Top250cell"];
    if ([totalArray count] > 0) {
        [tableCell setDelegate:self];
        [tableCell setRow:indexPath.row];
        NSMutableDictionary *dic = nil;
        if(indexPath.row * 3 < [totalArray count]){
            dic = [totalArray objectAtIndex:indexPath.row * 3 + 0];
            [tableCell.grid_first_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:bImage]]]];
            [tableCell.grid_first_label setText:[dic objectForKey:bName]];
        }
        if(indexPath.row * 3 + 1 < [totalArray count]){
            dic = [totalArray objectAtIndex:indexPath.row * 3 + 1];
            [tableCell.grid_second_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:bImage]]]];
            [tableCell.grid_second_label setText:[dic objectForKey:bName]];
        } else {
            [tableCell.grid_second_author setText:nil];
            [tableCell.grid_second_image setImage:nil];
            [tableCell.grid_second_label setText:nil];
        }
        if(indexPath.row * 3 + 2 < [totalArray count]){
            dic = [totalArray objectAtIndex:indexPath.row * 3 + 2];
            [tableCell.grid_third_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:bImage]]]];
            [tableCell.grid_third_label setText:[dic objectForKey:bName]];
        } else {
            [tableCell.grid_third_image setImage:nil];
            [tableCell.grid_third_author setText:nil];
            [tableCell.grid_third_label setText:nil];
        }
    }
    return tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TOP250viewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TOP250viewcontroller"];
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
    start += 25;
    [self loadRequest];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.mTableView];
}


- (void) gridCellItemClick:(NSInteger)index row:(NSInteger)row
{
    NSLog(@"%d- %d", index, row);
    bookId = [totalArray objectAtIndex:row * 3 + index - 1];
    //    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"top250detail" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"top250detail"]){
        BookDetailViewController *fc = (BookDetailViewController*)segue.destinationViewController;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[bookId objectForKey:bId] forKey:@"id"];
        [dic setObject:[bookId objectForKey:bName] forKey:@"title"];
        fc.mdouBook = [[DOUBook alloc] initWithDictionary:dic];
    } 
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [self setTotalArray:nil];
    [self setBookId:nil];
    [self setHud:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
