//
//  ThridViewController.h
//  douban-book
//
//  Created by xeodou on 12-12-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"


@interface ThridViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, LoginCallDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableview;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *intro;
- (IBAction)goToMyDouban:(id)sender;
@end
