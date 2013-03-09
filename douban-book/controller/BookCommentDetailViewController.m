//
//  BookCommentDetailViewController.m
//  douban-book
//
//  Created by xeodou on 13-2-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookCommentDetailViewController.h"
#import "MBProgressHUD.h"
#import "MobClick.h"

@interface BookCommentDetailViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation BookCommentDetailViewController
@synthesize reviewId;
@synthesize mWebView;
@synthesize hud;

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
    if (self.title != nil) {
        [self.navigationItem setTitle:self.title];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.douban.com/book/review/%@/", reviewId]];
    [mWebView setScalesPageToFit:YES];
    [mWebView setDelegate:self];
    [mWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma Webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //     [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_auth", nil)];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"bookcommentdetailviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"bookcommentdetailviewcontroller"];
}  

- (void)viewDidUnload
{
    [self setMWebView:nil];
    [self setHud:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [self setReviewId:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
