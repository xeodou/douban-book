//
//  BookDetailViewController.m
//  douban-book
//
//  Created by xeodou on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookDetailViewController.h"
#import "DOUAPIEngine.h"
#import "DOUQuery.h"
#import "DOUHttpRequest.h"
#import "DouQueryBook.h"
#import "GenDouService.h"
#import "DOUAPIConfig.h"
#import "MBProgressHUD.h"
#import "BuyBookViewController.h"
#import "AddCommentViewController.h"
#import "AnimationViewController.h"
#import "UtilHelper.h"
#import "BookCommentViewController.h"
#import "DOUBookCollection.h"
#import "UIHelper.h"
#import "MTStatusBarOverlay.h"
#import "MobClick.h"

@interface BookDetailViewController ()

@property (nonatomic, strong) NSString *identifer;
@property (nonatomic, assign) int select;
@property (nonatomic, assign) int isSelect;

@end

@implementation BookDetailViewController
@synthesize commentTextview;
@synthesize mbookInfoView;
@synthesize mbooAuthorInfoView;
@synthesize mFooterView;
@synthesize bookReview;
@synthesize mScrollview;
@synthesize mdouBook;
@synthesize mDetailView;
@synthesize readerStatusSege;
@synthesize isbn;
@synthesize rateView;
@synthesize popUpView;
@synthesize privateBtn;
@synthesize identifer;
@synthesize select;
@synthesize isSelect;

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
    [self loadBook];
    isSelect = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if ([UtilHelper isLogin] && isbn == nil && isSelect == -1) {
        [self getMybookState];
    }
}

- (void) initData
{
    [readerStatusSege setBackgroundImage:[UIImage imageNamed:@"book_status_sege_bg_n.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [readerStatusSege setBackgroundImage:[UIImage imageNamed:@"book_status_sege_bg_s.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [readerStatusSege setDividerImage:[UIImage imageNamed:@"nav_sege_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void) updateUi
{
    self.navigationItem.title = [mdouBook title];
    [mDetailView.image setImageWithURL:[[NSURL alloc]initWithString:[mdouBook mediumImage]] ];
    [mDetailView.originTitle setText:[mdouBook originTitle]];
    [mDetailView.author setText:[[mdouBook author] componentsJoinedByString:@","]];
    [mDetailView.translator setText:[[mdouBook translator] componentsJoinedByString:@","]];
    [mDetailView.pulisher setText:[mdouBook publisher]];
    [mDetailView.pulishDate setText:[mdouBook publishDateStr]];
    [mDetailView.pages setText:[mdouBook pages]];
    [mDetailView.ISBN setText:[mdouBook ISBN13]];
    [mDetailView.average setText:[mdouBook average]];
    [mDetailView.price setText:[mdouBook price]];
    [mDetailView reloadViews];
    [mbookInfoView.title setText:@"图书简介"];
    [mbookInfoView setContentText:[mdouBook summary]];
    [mScrollview addSubview:mbookInfoView];
    CGRect frame = mbookInfoView.frame;
    frame.origin.y = 270;
    [mbookInfoView setFrame:frame];
    CGFloat y = frame.origin.y + frame.size.height + 5;
    [mbooAuthorInfoView.title setText:@"作者简介"];
    [mbooAuthorInfoView setContentText:[mdouBook authorIntro]];
    [mScrollview addSubview:mbooAuthorInfoView];
    frame = mbooAuthorInfoView.frame;
    frame.origin.y = y;
    [mbooAuthorInfoView setFrame:frame];
    y = frame.origin.y + frame.size.height + 5;
    [mScrollview addSubview:mFooterView];
    frame = mFooterView.frame;
    frame.origin.y = y;
    [mFooterView setFrame:frame];
    y = frame.origin.y + frame.size.height + 10;
    [mScrollview setContentSize:CGSizeMake(self.mScrollview.frame.size.width, y)];
    if (isbn) {
        [self getMybookState];
    }
}


#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
//    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.popUpView.frame;
    newTextViewFrame.origin.y = 0;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    popUpView.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect frame = popUpView.frame;
    frame.origin.y = 100;
    [popUpView setFrame:frame];
    
    [UIView commitAnimations];
}


- (void) getMybookState
{
    if (mdouBook.identifier == nil) {
        return;
    }
    MTStatusBarOverlay *MTSB = [MTStatusBarOverlay sharedInstance];
    MTSB.animation = MTStatusBarOverlayAnimationFallDown;
    MTSB.detailViewMode = MTDetailViewModeHistory;     
//    [MTSB postMessage:@"正在获取收藏信息"];
    [readerStatusSege setEnabled:NO];
    DOUService *service = [[[GenDouService alloc] init] genDouService];
    service.apiBaseUrlString = kHttpsApiBaseUrl;
    DOUQuery *query = [DouQueryBook queryForCollectionById:mdouBook.identifier];
    DOUReqBlock block = ^(DOUHttpRequest *req){
        NSError *error = [req doubanError];
        [readerStatusSege setEnabled:YES];
        if (error) {
            isSelect = -1;
//            [MTSB postImmediateMessage:@"获取收藏信息失败！" duration:2.0 animated:YES];
            return;
        }
//        NSLog(@"%@", [req responseString]);
        DOUBookCollection *c = [[DOUBookCollection alloc] initWithString:[req responseString]];
        if ([c code] == 1001) {
            isSelect = -1;
//            [MTSB postImmediateMessage:@"您还未收藏该图书" duration:2.0 animated:YES];
            return;
        }
        if (c.comment != nil && ![c.comment isEqual:@""]) {
            [bookReview setText:c.comment];
        }
        if (c.status != nil) {
            isSelect = [self getInt:c.status];
            [readerStatusSege setSelectedSegmentIndex:isSelect];
        }
//        [MTSB postImmediateMessage:@"获取信息成功" duration:2.0 animated:YES];
    };
    [service get:query callback:block];
}


- (void)collect:(NSMutableDictionary*)dic
{
    MTStatusBarOverlay *MTSB = [MTStatusBarOverlay sharedInstance];
    MTSB.animation = MTStatusBarOverlayAnimationFallDown;
    MTSB.detailViewMode = MTDetailViewModeHistory;     
    [MTSB postMessage:@"正在收藏图书"];
    if (mdouBook.identifier == nil) {
        return;
    }
    DOUService *service = [[[GenDouService alloc] init] genDouService];
    service.apiBaseUrlString = kHttpsApiBaseUrl;
    DOUQuery *query = [DouQueryBook queryForCollectionById:mdouBook.identifier];
    DOUReqBlock block = ^(DOUHttpRequest *req){
        NSError *error = [req doubanError];
        if (error) {
            [MTSB postImmediateMessage:@"添加收藏信息失败！" duration:2.0 animated:YES];
            return;
        }
//        NSLog(@"%@", [req responseString]);
        DOUBookCollection *c = [[DOUBookCollection alloc] initWithString:[req responseString]];
        if (c.status != nil) {
            isSelect = [self getInt:c.status];
            [readerStatusSege setSelectedSegmentIndex:isSelect];
        }
        if (c.comment != nil && ![c.comment isEqual:@""]) {
            [bookReview setText:c.comment];
        }
        [MTSB postImmediateMessage:@"添加收藏信息成功！" duration:2.0 animated:YES];
    };
    [service postDic:query postBody:dic callback:block];
}

- (void)changeCollect:(NSMutableDictionary*)dic
{    
    MTStatusBarOverlay *MTSB = [MTStatusBarOverlay sharedInstance];
    MTSB.animation = MTStatusBarOverlayAnimationFallDown;
    MTSB.detailViewMode = MTDetailViewModeHistory;     
    [MTSB postMessage:@"正在修改收藏图书"];
    if (mdouBook.identifier == nil) {
        return;
    }
    DOUService *service = [[[GenDouService alloc] init] genDouService];
    service.apiBaseUrlString = kHttpsApiBaseUrl;
    DOUQuery *query = [DouQueryBook queryForCollectionById:mdouBook.identifier];
    DOUReqBlock block = ^(DOUHttpRequest *req){
        NSError *error = [req doubanError];
        if (error) {
            [readerStatusSege setSelectedSegmentIndex:isSelect];
            [MTSB postImmediateMessage:@"修改收藏信息失败！" duration:2.0 animated:YES];
            return;
        }
//        NSLog(@"%@", [req responseString]);
        DOUBookCollection *c = [[DOUBookCollection alloc] initWithString:[req responseString]];
        if (c.status != nil) {
            isSelect = [self getInt:c.status];
            [readerStatusSege setSelectedSegmentIndex:isSelect];
        }
        if (c.comment != nil && ![c.comment isEqual:@""]) {
            [bookReview setText:c.comment];
        }
        [MTSB postImmediateMessage:@"修改收藏信息成功！" duration:2.0 animated:YES];
    };
    [service putDic:query postBody:dic callback:block];
}

- (void)viewDidUnload
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self setIsbn:nil];
    [self setMdouBook:nil];
    [self setMDetailView:nil];
    [self setReaderStatusSege:nil];
    [self setMbookInfoView:nil];
    [self setMScrollview:nil];
    [self setMbooAuthorInfoView:nil];
    [self setMFooterView:nil];
    [self setIdentifer:nil];
    [self setPopUpView:nil];
    [self setCommentTextview:nil];
    [self setBookReview:nil];
    [self setRateView:nil];
    [self setPrivateBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) loadBook
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    if([mdouBook authorIntro] != nil && isbn == nil){
        [self updateUi];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    DOUService *service = [[[GenDouService alloc] init] genDouService];
    DOUQuery *query = nil;
    service.apiBaseUrlString = kHttpsApiBaseUrl;
    if(isbn != nil && [mdouBook authorIntro] == nil){
        query = [DouQueryBook queryForBookByIsbn:isbn];
    } else {
        query = [DouQueryBook queryForBookById:[mdouBook identifier]];
    }
    DOUReqBlock block = ^(DOUHttpRequest *req){
        //        [req setDownloadProgressDelegate:hud];
//        NSLog(@"%@", [req responseString]);
        NSError *error = [req doubanError];
        if(error){
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = NSLocalizedString(@"hud_info_book", nil);
            [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1.0];
            return ;
        }
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
        DOUBook *newBook = [[DOUBook alloc] initWithString:[req responseString]];
        self.mdouBook = newBook;
        [self updateUi];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };
    [service get:query callback:block];
}

- (void)dismissHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[BuyBookViewController class]]){
        BuyBookViewController *fc = (BuyBookViewController*)[segue destinationViewController];
        fc.bookId = [mdouBook identifier];
    } else if([[segue identifier] isEqual:@"addbookMark"]){
        AddCommentViewController *fc = (AddCommentViewController*)[segue destinationViewController];
        fc.bookId = mdouBook.identifier;
    } else if([[segue identifier] isEqual:@"resultanimation"]){
        AnimationViewController *fc = (AnimationViewController*)[segue destinationViewController];
        fc.bookId = mdouBook.identifier;
        fc.title = [NSString stringWithFormat:@"%@的笔记", mdouBook.title];
    } else if([[segue identifier] isEqual:@"bookLogin"]){
        LoginViewController *fc = (LoginViewController*)[segue destinationViewController];
        fc.delegate = self;
    } else if([[segue identifier] isEqual:@"userComment"]){
        BookCommentViewController *fc = (BookCommentViewController*)[segue destinationViewController];
        fc.bookId = mdouBook.identifier;
        fc.title = [NSString stringWithFormat:@"%@的书评",mdouBook.title];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"bookdetailviewcontrolelr"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"bookdetailviewcontroller"];
}  
#pragma loginDelegate

- (void)islogin:(BOOL)isLogin
{
    if (isLogin && identifer) {
        [self performSegueWithIdentifier:identifer sender:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)readStatusChange:(id)sender {
    if (![UtilHelper isLogin]) {
        [readerStatusSege setSelectedSegmentIndex:-1];
        [self performSegueWithIdentifier:@"bookLogin" sender:self];
        return;
    }
    select = [readerStatusSege selectedSegmentIndex];
    [readerStatusSege setSelectedSegmentIndex:-1];
    [self showDialog:readerStatusSege]; 
}

- (NSString*)getString:(int)i
{
    if (i == 0) {
        return @"wish";
    } else if(i == 1){
        return @"reading";
    } else if (i == 2) {
        return @"read";
    }
    return nil;
}

- (int)getInt:(NSString*)str
{
    if ([str isEqual:@"wish"]) {
        return 0;
    } else if ([str isEqual:@"reading"]) {
        return 1;
    } else if ([str isEqual:@"read"]) {
        return 2;
    }
    return -1;
}

- (IBAction)bookUserCommentClick:(id)sender {
    [self performSegueWithIdentifier:@"userComment" sender:self];
}

- (IBAction)bookCommentClick:(id)sender {
    [self performSegueWithIdentifier:@"resultanimation" sender:self];
}

- (IBAction)addBookMarkClick:(id)sender {
    identifer = @"addbookMark";
    if ([UtilHelper isLogin]) {
        [self performSegueWithIdentifier:@"addbookMark" sender:self];
    } else {
        [self performSegueWithIdentifier:@"bookLogin" sender:self];
    }
}


- (IBAction)showDialog:(id)sender {
    if (![[bookReview text] isEqual:@"点击添加书评"]) {
        [commentTextview setText:[bookReview text]];
    }
    [self.view addSubview:popUpView];
    CGRect frame = popUpView.frame;
    frame.origin = CGPointMake(16, 100);
    [popUpView setFrame:frame];
    [popUpView showFromPoint:[sender center]];
    
}

- (IBAction)completeBtnClick:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%d", [rateView rate]] forKey:@"rating"];
    if ([commentTextview text] != nil) {
        [dic setObject:[commentTextview text] forKey:@"comment"];
    }
    if ([privateBtn isSelected]) {
        [dic setObject:@"private" forKey:@"privacy"];
    } else {
        [dic setObject:@"private" forKey:@"public"];
    }
    [dic setObject:[self getString:select]forKey:@"status"];
    if (isSelect >= 0) {
        [self changeCollect:dic];
    } else {
        [self collect:dic];
    }
    [commentTextview resignFirstResponder];
    [popUpView hide];
}

- (IBAction)closebtnClick:(id)sender {
    [readerStatusSege setSelectedSegmentIndex:isSelect];
    [commentTextview resignFirstResponder];
    [popUpView hide];
}

- (IBAction)privateBtnClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
}

@end
