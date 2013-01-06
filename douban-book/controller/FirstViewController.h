//
//  FirstViewController.h
//  douban-book
//
//  Created by xeodou on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DropDownView.h"

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet DropDownView *mDropDownView;

@end
