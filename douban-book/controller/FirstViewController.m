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
#import "DOUBook.h"
#import "UtilHelper.h"
#import "BookDetailViewController.h"
#import "PrettyKit.h"
#import "UIHelper.h"
#import "MBProgressHUD.h"
#import "MobClick.h"
#import "ASIDownloadCache.h"

@interface FirstViewController ()
@property (nonatomic, strong) NSMutableArray* marrTotal;
@property (nonatomic, strong) DOUBook* mdoubook;
@property (nonatomic, strong) NSString* isbn;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isAticle;
@end

@implementation FirstViewController
@synthesize mSegement;
@synthesize mTableView;
@synthesize marrTotal;
@synthesize mdoubook;
@synthesize isbn;
@synthesize hud;
@synthesize data;
@synthesize refreshHeaderView;
@synthesize reloading;
@synthesize isAticle;

- (void)viewDidLoad
{
    //add this 2 lines:
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
  //      [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    [self customNav];
    [self initData];
    [self loadRequest];
}

- (void) loadRequest
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://book.douban.com/latest"]];
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
    [self showAlert:NSLocalizedString(@"alert_msg_new_book_error", nil)];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
    data = [request responseData];
    if (!isAticle) {
        [self loadFabArticle:data];
    } else {
        [self loadunFabArticle:data];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([marrTotal count] <= 0) {
        [self showAlert:NSLocalizedString(@"alert_msg_new_book_error", nil)];
    }
    [self reloadTableViewDataSource];
    [self doneLoadingTableViewData];
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

- (void) loadFabArticle:(NSData*)response
{
    [marrTotal removeAllObjects];
    [marrTotal addObjectsFromArray:[self loadDoubanBook:@"//div[@class='article']/ul/li" data:response]];
}

- (void) loadunFabArticle:(NSData*)response
{
    [marrTotal removeAllObjects];
    [marrTotal addObjectsFromArray:[self loadDoubanBook:@"//div[@class='aside']/ul/li" data:response]];
}

- (NSMutableArray*)loadDoubanBook:(NSString*)query data:(NSData*)response

{   
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:response];
    NSArray *elements = [doc searchWithXPathQuery:query];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in elements) {
        DOUBook *book = [[DOUBook alloc] init];
        if(element != nil){
            //NSLog(@"%@", [element description]);
            NSArray *arr = [element children];
            if([arr count] > 0){
                NSString *str = nil;
                TFHppleElement *el = (TFHppleElement*)[arr objectAtIndex:1];
                NSArray *arrChild = [el children];
                if([arrChild count] > 0){
                    str = [[[(TFHppleElement*)[arrChild objectAtIndex:1] children] objectAtIndex:0] content];
                    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    [[book dictionary] setObject:str forKey:@"title"];
                }
                el = (TFHppleElement*)[arr objectAtIndex:3];
                str = [el objectForKey:@"href"];
                if(str != nil){
                    str = [UtilHelper regMatcher:str regex:@"([1-9]\\d*)" rangeIndex:0];
                    if(str != nil){
                        [[book dictionary] setObject:str forKey:@"id"];
                    }
                }
                arrChild = [el children];
                if([arrChild count] > 0){
                    str = [[arrChild objectAtIndex:0] objectForKey:@"src"];
                    //                    NSLog(@"%@", str);
                    if(str != nil){
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setValue:str forKey:@"medium"];
                        [[book dictionary] setObject:dic forKey:@"images"];
                    }
                }
                [array addObject:book];
            }
        }
    }
    return array;
}

- (void) initData 
{    
    isAticle = NO;
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    marrTotal = [[NSMutableArray alloc] init];
    data = [[NSData alloc] init];
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mTableView.bounds.size.height, self.view.frame.size.width, self.mTableView.bounds.size.height)];
    [refreshHeaderView setDelegate:self];
    [mTableView addSubview:refreshHeaderView];
    [refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidAppear:(BOOL)animated
{
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"firtviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"firstviewcontroller"];
}  

- (void) customNav
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 22, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_scan_n.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_scan_p.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(toBoardScan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item2.width = -10;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:item2, item, nil]];
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 22, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_search_n.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_search_p.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(toSearchController) forControlEvents:UIControlEventTouchUpInside];
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    item2.width = 10;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:item2, item, nil]];
    [mSegement setBackgroundImage:[UIImage imageNamed:@"nav_sege_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [mSegement setBackgroundImage:[UIImage imageNamed:@"nav_sege_bg_s.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [mSegement setDividerImage:[UIImage imageNamed:@"nav_sege_divider.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [mSegement setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x5cae68],UITextAttributeTextColor,[UIColor clearColor], UITextAttributeTextShadowColor,nil] forState:UIControlStateNormal];
    [mSegement setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
}

- (void) toSearchController 
{
    [MobClick event:@"search"];
    [self performSegueWithIdentifier:@"searchsegue" sender:self];
}

- (void) toBoardScan
{
    [MobClick event:@"scan"];
    [self performSegueWithIdentifier:@"indexToscaner" sender:self];
    
}

- (void)viewDidUnload
{
    [self setIsbn:nil];
    [self setData:nil];
    [self setMTableView:nil];
    [self setMSegement:nil];
    [self setTitle:nil];
    [self setMarrTotal:nil];
    [self setMdoubook:nil];
    [self setHud:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrTotal count] % 3 == 0 ? [marrTotal count] / 3 : [marrTotal count] / 3 + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomGridCell *tableCell = (CustomGridCell*)[tableView dequeueReusableCellWithIdentifier:@"BookGridCell"];
    [tableCell setDelegate:self];
    [tableCell setRow:indexPath.row];
    NSLog(@"%@",[NSString stringWithFormat:@"%@", [(DOUBook*)[marrTotal objectAtIndex:indexPath.row * 3 + 0] identifier]
                 ]);
    DOUBook *book = [[DOUBook alloc] init];
    if(indexPath.row * 3 < [marrTotal count]){
        book = (DOUBook*)[marrTotal objectAtIndex:indexPath.row * 3 + 0];
        [tableCell.grid_first_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [book mediumImage]]]];
        [tableCell.grid_first_label setText:[book title]];
    }
    if(indexPath.row * 3 + 1 < [marrTotal count]){
        book = (DOUBook*)[marrTotal objectAtIndex:indexPath.row * 3 + 1];
        [tableCell.grid_second_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [book mediumImage]]]];
        [tableCell.grid_second_label setText:[book title]];
    } else {
        [tableCell.grid_second_author setText:nil];
        [tableCell.grid_second_image setImage:nil];
        [tableCell.grid_second_label setText:nil];
    }
    if(indexPath.row * 3 + 2 < [marrTotal count]){
        book = (DOUBook*)[marrTotal objectAtIndex:indexPath.row * 3 + 2];
        [tableCell.grid_third_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [book mediumImage]]]];
        [tableCell.grid_third_label setText:[book title]];
    } else {
        [tableCell.grid_third_image setImage:nil];
        [tableCell.grid_third_author setText:nil];
        [tableCell.grid_third_label setText:nil];
    }
    return tableCell;
}

- (void) gridCellItemClick:(NSInteger)index row:(NSInteger)row
{
    NSLog(@"%d- %d", index, row);
    NSLog(@"%@",[[marrTotal objectAtIndex:row * 3 + index - 1] title]);
    mdoubook = [marrTotal objectAtIndex:row * 3 + index - 1];
//    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"bookdetail" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"bookdetail"]){
        BookDetailViewController *fc = (BookDetailViewController*)segue.destinationViewController;
        fc.mdouBook = mdoubook;
    } else if([[segue identifier] isEqual:@"indexToscaner"]){
        ScanerViewController *fc = (ScanerViewController*)[segue destinationViewController];
//        fc.parent = self;
        fc.delegate = self;
    } else if([[segue identifier] isEqual:@"isbnResult"]){
        BookDetailViewController *fc = (BookDetailViewController*)segue.destinationViewController;
        fc.isbn = isbn;
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [mTableView reloadData];
	reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
	//  model should call this when its done loading
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:mTableView];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
	[self performSelector:@selector(loadRequest) withObject:nil afterDelay:1.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
	return reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
    
}



- (void) scanSuccess:(NSString *)result
{
    self.isbn = result;
    NSLog(@"fist%@", result);
    [self performSegueWithIdentifier:@"isbnResult" sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void) dropviewitemClick:(NSInteger)position
{
    if (data == nil) {
        return;
    }
    switch (position) {
        case 0:
//            title = @"虚构";
            [self loadFabArticle:data];
            isAticle = NO;
//            [self.parentViewController.navigationItem setTitle:title];
            break;
            
        case 1:
//            title = @"非虚构";
            isAticle = YES;
            [self loadunFabArticle:data];
//            [self.parentViewController.navigationItem setTitle:title];
            break;
    }
    [[self mTableView] reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0f;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)segementClick:(id)sender {
    UISegmentedControl *sc = (UISegmentedControl*)sender;
    [self dropviewitemClick:[sc selectedSegmentIndex]];
}
@end
