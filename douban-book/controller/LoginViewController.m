//
//  LoginViewController.m
//  douban-book
//
//  Created by xeodou on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "DOUAPIEngine.h"
#import "UIHelper.h"
#import "DouQueryUser.h"
#import "GenDouService.h"
#import "DOUUser.h"
#import "UserDB.h"
#import "UIHelper.h"
#import "MobClick.h"
#import "PrettyDrawing.h"
#import "Constants.h"


@interface NSString (ParseCategory)
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue 
                                           outterGlue:(NSString *)outterGlue;
@end

@implementation NSString (ParseCategory)

- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue 
                                           outterGlue:(NSString *)outterGlue {
    // Explode based on outter glue
    NSArray *firstExplode = [self componentsSeparatedByString:outterGlue];
    NSArray *secondExplode;
    
    // Explode based on inner glue
    NSInteger count = [firstExplode count];
    NSMutableDictionary* returnDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        secondExplode = 
        [(NSString*)[firstExplode objectAtIndex:i] componentsSeparatedByString:innerGlue];
        if ([secondExplode count] == 2) {
            [returnDictionary setObject:[secondExplode objectAtIndex:1] 
                                 forKey:[secondExplode objectAtIndex:0]];
        }
    }
    return returnDictionary;
}

@end

@interface LoginViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation LoginViewController
@synthesize delegate;
@synthesize webview;
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
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0x5CAE68]];
//    [self setNeedsStatusBarAppearanceUpdate];
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout=UIRectEdgeNone;
//    }
    [self initData];
}

- (void)initData
{
    NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code&scope=douban_basic_common,book_basic_r,book_basic_w", appkey, redirectUrl];
    
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [webview setScalesPageToFit:YES];
    [webview setDelegate:self];
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma Webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
    NSLog(@"%@", str);
    if ([str rangeOfString:@"invalid_request: not_trial_user:"].location != NSNotFound) {
        [MBProgressHUD hideHUDForView:self.webview animated:YES];
        [self showAlert];
        return;
    }
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
    [MBProgressHUD hideHUDForView:self.webview animated:YES];
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title_info", nil) message:NSLocalizedString(@"alert_msg_not_tial", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"alert_btn_ok", @"nil")otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        DOUOAuthService *service = [DOUOAuthService sharedInstance];
        [service logout];
    }
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    hud = [MBProgressHUD showHUDAddedTo:self.webview animated:YES];
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//     [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_auth", nil)];
    [MBProgressHUD hideHUDForView:self.webview animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *urlObj =  [request URL];
    NSString *url = [urlObj absoluteString];
    
    
    if ([url hasPrefix:redirectUrl]) {
        
        NSString* query = [urlObj query];
        NSMutableDictionary *parsedQuery = [query explodeToDictionaryInnerGlue:@"=" 
                                                                    outterGlue:@"&"];
        
        //access_denied
        NSString *error = [parsedQuery objectForKey:@"error"];
        if (error) {
            return NO;
        }
//        hud = [MBProgressHUD showHUDAddedTo:self.webview animated:YES];
        hud.labelText = NSLocalizedString(@"hud_info_author", nil);
        //access_accept
        NSString *code = [parsedQuery objectForKey:@"code"];
        DOUOAuthService *service = [DOUOAuthService sharedInstance];
        service.authorizationURL = kTokenUrl;
        service.delegate = self;
        service.clientId = appkey;
        service.clientSecret = appsecret;
        service.callbackURL = redirectUrl;
        service.authorizationCode = code;
        
        [service validateAuthorizationCode];
        
        return NO;
    }
    
    return YES;
}


- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
    NSLog(@"success!");
    hud = [MBProgressHUD showHUDAddedTo:self.webview animated:YES];
    hud.labelText = NSLocalizedString(@"hud_info_auth", nil);
    [self getAuthUser];
}

- (BOOL)getAuthUser
{
    hud.labelText = NSLocalizedString(@"hud_info_user_info", nil);
    DOUService *service = [DOUService sharedInstance];
    service.apiBaseUrlString = kHttpsApiBaseUrl;
    DOUQuery *query = [DouQueryUser querForSelf];
    DOUReqBlock block = ^(DOUHttpRequest *req){
//        NSLog(@"%@", [req responseString]);
        NSError *err = [req doubanError];
        if (err) {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            hud.mode = MBProgressHUDModeCustomView;
            if ([err code] == 108) {
                [MBProgressHUD hideHUDForView:self.webview animated:YES];
                [self showAlert];
            } else {
                hud.labelText = NSLocalizedString(@"hud_info_user_info_err", nil);
            }
            return;
        }
        DOUUser *user = [[DOUUser alloc] initWithString:[req responseString]];
        UserDB *userDb = [[UserDB alloc] init];
        [userDb insertUser:user];
        [userDb close];
        [MBProgressHUD hideHUDForView:self.webview animated:YES];
        [[self delegate] islogin:YES];
        [self dismissModalViewControllerAnimated:YES];
    };
    [service get:query callback:block];
    return YES;
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
    NSLog(@"Fail!");
    [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_auth", nil)];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"loginviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"loginviewcontroller"];
}  

- (void)viewDidUnload
{
    [self setWebview:nil];
    [self setHud:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [self setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeBtnClick:(id)sender {
    [[self delegate] islogin:NO];
    [self dismissModalViewControllerAnimated:YES];
}
@end
