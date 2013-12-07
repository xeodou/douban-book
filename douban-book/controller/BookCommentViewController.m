//
//  BookCommentViewController.m
//  douban-book
//
//  Created by xeodou on 13-2-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookCommentViewController.h"
#import "MBProgressHUD.h"
#import "TFHpple.h"
#import "AnimationCell.h"
#import "UIHelper.h"
#import "BookCommentDetailViewController.h"
#import "PrettyDrawing.h"
#import "MobClick.h"

@interface BookCommentViewController ()

@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, assign)int start;
@property (nonatomic, strong) NSMutableArray *totalarray;
@property (nonatomic, assign)int seleccted;

@end


@implementation BookCommentViewController
@synthesize bookId;
@synthesize mTableView;
@synthesize hud;
@synthesize start;
@synthesize totalarray;
@synthesize title;
@synthesize seleccted;

NSString * const cId = @"cId";
NSString * const cAuthorName = @"name";
NSString * const cAuthorImage = @"image";
NSString * const cAbstract = @"abstarct";
NSString * const cTitle = @"title";

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
    [self initData];
    [self loadArray];
}

- (void)initData
{
    if (title != nil) {
        [self.navigationItem setTitle:title];
    }
    start = 0;
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    totalarray = [[NSMutableArray alloc] init];
    if (_loadMoreFooterView == nil) {		
		LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.mTableView.contentSize.height, self.mTableView.frame.size.width, self.mTableView.bounds.size.height)];
		view.delegate = self;
		[self.mTableView addSubview:view];
		_loadMoreFooterView = view;
		
	}	
}

- (void) loadArray
{
    if (start > [totalarray count]) {
        [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_book_anno", nil)];
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    if(bookId == nil){
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"错误的图书Id,请返回重试！";
        return;
    }
    NSString *str = [NSString stringWithFormat:@"http://book.douban.com/subject/%@/reviews?start=%d", bookId, start];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setCachePolicy:ASIUseDefaultCachePolicy];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlert:NSLocalizedString(@"alert_msg_error_anno", nil)];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    if(![self loadData:[request responseData]]){
        [self showAlert:NSLocalizedString(@"alert_msg_error_anno", nil)];
        return;
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [mTableView reloadData];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loadArray];
    }
}

- (void) showAlert:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title_info", nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"alert_btn_cancel", nil) otherButtonTitles:NSLocalizedString(@"alert_btn_retry", nil), nil];
    [alert show];
}

- (BOOL)loadData:(NSData*)data
{
    TFHpple *tf = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *arr = [tf searchWithXPathQuery:@"//div[@class='ctsh']/div"];
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in arr) {
        NSArray *array = [element childrenWithTagName:@"div"];
        if ([array count] ==  3) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            TFHppleElement *e  = [array objectAtIndex:0];
            e = [e firstChildWithTagName:@"a"];
            NSString *str = [[e attributes] objectForKey:@"title"];
            [dic setObject:str forKey:cAuthorName];
            e = [e firstChildWithTagName:@"img"];
            str = [[e attributes] objectForKey:@"src"];
            [dic setObject:str forKey:cAuthorImage];
            e = [array objectAtIndex:1];
            e = [e firstChildWithTagName:@"h3"];
            e = [e firstChildWithTagName:@"a"];
            str = [[e attributes] objectForKey:@"title"];
            [dic setObject:str forKey:cTitle];
            str = [[e attributes] objectForKey:@"href"];
            str = [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
            [dic setObject:str forKey:cId];
            e = [array objectAtIndex:2];
            e = [e firstChildWithTagName:@"div"];
//            NSLog(@"%@", [[[e firstChildWithTagName:@"span"] firstChild] content]);
            str = [[[e firstChildWithTagName:@"span"] firstChild] content];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [dic setObject:str forKey:cAbstract];
            [a addObject:dic];
        }
    }
    //update no comments fix
    if ([a count] == 0 && start == 0) {
        [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_no_comment", nil)];
        return YES;
    }
    if ([a count] <= 0) {
        return NO;
    }
    [totalarray addObjectsFromArray:a];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [totalarray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnimationCell *cell = (AnimationCell*)[tableView dequeueReusableCellWithIdentifier:@"bookannotationcell"];
    if ([totalarray count] > 0) {
        NSMutableDictionary *dic = [totalarray objectAtIndex:indexPath.row];
        [cell.image setImageWithURL:[NSURL URLWithString:[dic objectForKey:cAuthorImage]]];
        [cell.name setText:[dic objectForKey:cAuthorName]];
        [cell.title setText:[dic objectForKey:cTitle]];
        [cell.abstract setText:[dic objectForKey:cAbstract]];
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [v setBackgroundColor:[UIColor colorWithHex:0xedf4ed]];
    [cell setSelectedBackgroundView:v];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    seleccted = indexPath.row;
    [self performSegueWithIdentifier:@"commentDetail" sender:self];
    [self performSelector:@selector(deselect:) withObject:nil afterDelay:0.2];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"commentDetail"]) {
        BookCommentDetailViewController *fc = (BookCommentDetailViewController*)[segue destinationViewController];
        fc.reviewId = [[totalarray objectAtIndex:seleccted] objectForKey:cId];
        fc.title = [[totalarray objectAtIndex:seleccted] objectForKey:cTitle];
    }
}

- (void) deselect:(id)sender
{
    [self.mTableView deselectRowAtIndexPath:[self.mTableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"bookcommentviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"bookcommentviewcontroller"];
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
    [self loadArray];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.mTableView];
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [self setTotalarray:nil];
    [self setTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [self setBookId:nil];
    [self setHud:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
