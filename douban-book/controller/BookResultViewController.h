//
//  BookResultViewController.h
//  douban-book
//
//  Created by xeodou on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomViewController.h"
#import "LoadMoreTableFooterView.h"


@interface BookResultViewController : CustomViewController<UITableViewDataSource, UITableViewDelegate, LoadMoreTableFooterDelegate, UIAlertViewDelegate>{
    
	LoadMoreTableFooterView *_loadMoreFooterView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *uid;

@end
