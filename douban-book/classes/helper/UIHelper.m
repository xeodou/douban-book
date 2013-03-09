//
//  UIHelper.m
//  douban-book
//
//  Created by xeodou on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper


+ (void) showAlert:(NSString*)title msg:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_btn_ok", @"nil")otherButtonTitles:nil, nil];
    [alert show];
}

@end
