//
//  FirstViewController.h
//  douban-book
//
//  Created by xeodou on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomGridCell.h"
#import "ScanerViewController.h"
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GridCellItemClickDelegate, ScanerViewDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate,EGORefreshTableHeaderDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *mSegement;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)segementClick:(id)sender;
@end
