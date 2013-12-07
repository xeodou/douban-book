//
//  SecondViewController.m
//  douban-book
//
//  Created by xeodou on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "BookTagCell.h"
#import "MBProgressHUD.h"
#import "TFHpple.h"
#import "UIHelper.h"
#import "BookResultViewController.h"
#import "MobClick.h"
#import "Constants.h"
#import "ASIDownloadCache.h"

#define TITLE @"title"
#define TAGS @"tags"

@interface SecondViewController ()

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSString *currenTtag;
@property (nonatomic, strong)  MBProgressHUD *hud;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isRefresh;
@end

@implementation SecondViewController
@synthesize mTableView;
@synthesize tags;
@synthesize currenTtag;
@synthesize hud;
@synthesize reloading;
@synthesize refreshHeaderView;
@synthesize isRefresh;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self loadRequest];
}

- (void) loadRequest
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://book.douban.com/tag/?view=type"]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    if (isRefresh) {
        [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    } else {
        [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    }
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [[ ASIDownloadCache sharedCache ] setShouldRespectCacheControlHeaders:NO ];
    [request setSecondsToCache:60*60*24*7];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
//    BOOL success = [request didUseCachedResponse];
//    NSLog(@"------------>>>>>>> Success is %@\n", (success ? @"YES" : @"NO"));
    if(![self loadData:[request responseData]]){
        [self showAlert:NSLocalizedString(@"alert_msg_tag_eror", nil)];
        return;
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
    }
    [self reloadTableViewDataSource];
    [self doneLoadingTableViewData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loadRequest];
    }
}

- (void) showAlert:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title_info", nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"alert_btn_cancel", nil) otherButtonTitles:NSLocalizedString(@"alert_btn_retry", nil), nil];
    [alert show];
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlert:NSLocalizedString(@"alert_msg_tag_eror", nil)];
}

- (BOOL)loadData:(NSData*)data
{
    NSArray *titles = nil;
    
    if (SYSTEM_VERSION_GREATER_THAN(@"6.0") && SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        // IOS version equal 6.1.x
        // Fix iOS 6.1 bug.
        titles = [self regexTitlesForIos6_1_x:[self genTf:data] query:@"//div/div/div/a[@name]"];
    } else {
        titles = [self regexTitles:[self genTf:data] query:@"//div[@class='article']/div/div/a"];
    }
    
    NSArray *child = [self regexTags:[self genTf:data] query:@"//table[@class='tagCol']/tbody"];
    if(titles == nil|| child == nil || [titles count] < 1 || [child count] < 1){
        return NO;
    }
    NSInteger count = [titles count];
    if(count < [child count]){
        count = [child count];
    }
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[titles objectAtIndex:i] forKey:TITLE];
        [dic setObject:[child objectAtIndex:i] forKey: TAGS];
        [tags addObject:dic];
    }
    return YES;
}

- (TFHpple*) genTf:(NSData*)data
{
    TFHpple *tf = [[TFHpple alloc] initWithHTMLData:data];
    return tf;
}

- (NSArray*)regexTitlesForIos6_1_x:(TFHpple*)tf query:(NSString*)query
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *elements = [tf searchWithXPathQuery:query];
//    NSLog(@"%@", elements);
    for(TFHppleElement *element in elements){
        NSString *str = [[element attributes] objectForKey:@"name"];
        NSLog(@"%@", str);
        [array addObject:str];
    }
    return array;
}

- (NSArray*)regexTitles:(TFHpple*)tf query:(NSString*)query
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *elements = [tf searchWithXPathQuery:query];
//    NSLog(@"%@", elements)
    for(TFHppleElement *element in elements){
        NSString *str = [[element attributes] objectForKey:@"name"];
        NSLog(@"%@", str);
        [array addObject:str];
    }
    return array;
}

- (NSArray*)regexTags:(TFHpple*)tf query:(NSString*)query
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *elements = [tf searchWithXPathQuery:query];
    for(TFHppleElement *element in elements){
//        NSLog(@"%@", [element children]);
        NSArray *arr = [element children];
        NSMutableArray *child = [[NSMutableArray alloc] init];
        for( TFHppleElement *el in arr) {
            NSArray *a = [el children];
            for(TFHppleElement *e in a){
                if ([[e children] count] > 0) {
                    NSString *str = [[[[[e children] objectAtIndex:0] children] objectAtIndex:0] content];
//                    NSLog(@"%@", str);
                    [child addObject:str];
                }
            }
        }
        [array addObject:child];
    }
    return array;
}

- (void) initData
{
    isRefresh = NO;
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    tags = [[NSMutableArray alloc] init];
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mTableView.bounds.size.height, self.view.frame.size.width, self.mTableView.bounds.size.height)];
    [refreshHeaderView setDelegate:self];
    [mTableView addSubview:refreshHeaderView];
    [refreshHeaderView refreshLastUpdatedDate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tags count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTagCell *cell = (BookTagCell*)[tableView dequeueReusableCellWithIdentifier:@"BookTagsCell"];
    cell.delegate = self;
    if (cell==nil) {
        cell= [[BookTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookTagsCell"] ;
    }else{
       NSArray *subs = [[NSArray alloc] initWithArray:cell.tagView.subviews];
        for (UIView *sub in subs) {
        [sub removeFromSuperview];
       }
    }

    if([tags count] > 0){
        NSMutableDictionary *dic = [tags objectAtIndex:indexPath.row];
        [cell.title setText:[dic objectForKey:TITLE]];
        [cell setTags:[dic objectForKey:TAGS]];
    }
    return cell;
}

- (void)tagClick:(NSString *)tag
{
    if(tag == nil){
        return;
    }
    currenTtag = tag;
    [self performSegueWithIdentifier:@"tagsResult" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[BookResultViewController class]]){
        BookResultViewController *fc = (BookResultViewController*)segue.destinationViewController;
        fc.tag = currenTtag;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTagCell *cell = (BookTagCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.parentViewController.navigationItem setLeftBarButtonItem:nil];
    [self.parentViewController.navigationItem setTitleView:nil];
    [self.parentViewController.navigationItem setTitle:@"所有标签"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"secondviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"secondviewcontroller"];
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
    
    isRefresh = YES;
    [self reloadTableViewDataSource];
	[self performSelector:@selector(loadRequest) withObject:nil afterDelay:1.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
	return reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
    
}

- (void)viewDidUnload
{
    [self setRefreshHeaderView:nil];
    [self setMTableView:nil];
    [self setHud:nil];
    [self setTags:nil];
    [self setCurrenTtag:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
