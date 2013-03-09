//
//  LoginViewController.h
//  douban-book
//
//  Created by xeodou on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOUOAuthService.h"

@protocol LoginCallDelegate <NSObject>

- (void) islogin:(BOOL)isLogin;

@end

@interface LoginViewController : UIViewController<UIWebViewDelegate, DOUOAuthServiceDelegate, UIAlertViewDelegate>
{
    id<LoginCallDelegate> delegate;
}

@property (nonatomic, strong) id<LoginCallDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)closeBtnClick:(id)sender;
@end
