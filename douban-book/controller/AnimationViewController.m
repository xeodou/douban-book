//
//  AnimationViewController.m
//  douban-book
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AnimationViewController.h"
#import "AnimationCell.h"
#import "GenDouService.h"
#import "MBProgressHUD.h"
#import "DOUAPIConfig.h"
#import "DouQueryBook.h"
#import "DOuBookAnnotationArray.h"
#import "DouBookAnnotation.h"
#import "UIHelper.h"
#import "PrettyDrawing.h"
#import "BookDetailViewController.h"
#import "UIHelper.h"
#import "MobClick.h"
#import "AnnotationDetailViewController.h"

@interface AnimationViewController ()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) int select;
@property (nonatomic, assign) BOOL isDrop;
@property (nonatomic, assign) int startCount;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@end

@implementation AnimationViewController
@synthesize mTableview;
@synthesize array;
@synthesize bookId;
@synthesize uid;
@synthesize hud;
@synthesize title;
@synthesize select;
@synthesize isDrop;
@synthesize startCount;
@synthesize selectIndexPath;

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
    [self loadData:startCount count:20];
}

- (void) initData
{
    startCount = 0;
    [mTableview setDelegate:self];;
    [mTableview setDataSource:self];
    array = [[NSMutableArray alloc] init];
    [self.navigationItem setTitle:title];
    if (_loadMoreFooterView == nil) {		
		LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.mTableview.contentSize.height, self.mTableview.frame.size.width, self.mTableview.bounds.size.height)];
		view.delegate = self;
		[self.mTableview addSubview:view];
		_loadMoreFooterView = view;
		
	}	
}

- (void) loadData:(NSInteger)start count:(NSInteger) count
{
    if (startCount > [array count]) {
        [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_book_annotation", nil)];
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    DOUService *sevice = [[[GenDouService alloc] init] genDouService];
    sevice.apiBaseUrlString = kHttpsApiBaseUrl;
    DOUQuery *query = nil;
    if (uid != nil) {
        query = [DouQueryBook queryForAnnotationByName:uid start:start count:count];
    } else {
        query = [DouQueryBook queryForAnnotaionByBookId:bookId start:start count:count];
    }
    DOUReqBlock block = ^(DOUHttpRequest *req){
        NSError *error = [req doubanError];
        if(error){
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = NSLocalizedString(@"hud_info_annomation", nil);
            return;
        }
        DOUBookAnnotationArray *arr = [[DOUBookAnnotationArray alloc] initWithString:[req responseString]];
        [array addObjectsFromArray:[arr objectArray]];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
        [self performSelector:@selector(hiddenHUD) withObject:nil afterDelay:0.5];
        if ([array count] <= 0) {
            [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_no_annotation", nil)];
        } else {
            [self updateUi];
        }
    };
    [sevice get:query callback:block];
}

- (void)updateUi
{
    [mTableview reloadData];
}

- (void) hiddenHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    AnimationCell *cell = (AnimationCell*)[tableView dequeueReusableCellWithIdentifier:@"animationcell"];
    if (array != nil) {
        DouBookAnnotation *ba = [array objectAtIndex:indexPath.row];
        if(uid != nil){
            [cell.image setImageWithURL:[NSURL URLWithString:ba.book.mediumImage]];
            [cell.name setText:ba.book.title];
        } else {
            [cell.image setImageWithURL:[NSURL URLWithString:ba.author.avatar]];
            [cell.name setText:ba.author.name];
        }
        if ([ba.chapter isEqual:@""]) {
            [cell.title setText:@"暂无章节名"];
        } else {
            [cell.title setText:ba.chapter];
        }
        if (uid) {
            cell.bookId = ba.book.identifier;
            cell.delegate = self;
        }
        [cell.page setText:[NSString stringWithFormat:@"第%d页   写于%@",ba.pageNo, ba.time]];
        [cell.abstract setText:ba.abstract];
        [cell viewWithTag:10312839].hidden = YES;
//        if (![[cell viewWithTag:10312839] isHidden]) {
//            [cell setCOntentText:ba.content];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (select == indexPath.row && isDrop) {
//            [cell showDrop:YES];
//        } else {
//            [cell showDrop:NO];
//        }
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [v setBackgroundColor:[UIColor colorWithHex:0xedf4ed]];
    [cell setSelectedBackgroundView:v];
    return cell;
}

- (void)AnnotationClick:(NSString *)bid
{
    bookId = bid;
    [self performSegueWithIdentifier:@"annotationTodetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"annotationTodetail"]) {
        BookDetailViewController *fc = (BookDetailViewController*)[segue destinationViewController];
        fc.mdouBook = [[DOUBook alloc] initWithDictionary:[NSMutableDictionary dictionaryWithObject:bookId forKey:@"id"]];
    } else if ([[segue identifier] isEqual:@"annotationDetail"]) {
        AnnotationDetailViewController *fc = (AnnotationDetailViewController*)[segue destinationViewController];
        fc.annot = [array objectAtIndex:selectIndexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndexPath = indexPath;
    [self performSegueWithIdentifier:@"annotationDetail" sender:self];
    [self performSelector:@selector(deselect:) withObject:nil afterDelay:0.2];
}

- (void) deselect:(id)sender
{
    [self.mTableview deselectRowAtIndexPath:[self.mTableview indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BookTagCell *cell = (BookTagCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        AnimationCell *cell = (AnimationCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        UIView *view = [cell viewWithTag:10312839];
//        view.hidden = !view.hidden;
        return 100.0;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];		
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
	
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"annotationviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"annotationviewcontroller"];
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
    startCount += 20;
    [self loadData:startCount count:20];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.mTableview];
}


- (void)viewDidUnload
{
    [self setMTableview:nil];
    [self setSelectIndexPath:nil];
    [self setHud:nil];
    [self setArray:nil];
    [self setBookId:nil];
    [self setUid:nil];
    [self setTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"------");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
