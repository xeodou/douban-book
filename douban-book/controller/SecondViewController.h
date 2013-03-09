//
//  SecondViewController.h
//  douban-book
//
//  Created by xeodou on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookTagCell.h"
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"


@interface SecondViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, TagClickDelegte, ASIHTTPRequestDelegate,UIAlertViewDelegate, EGORefreshTableHeaderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@end
