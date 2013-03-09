//
//  Top250ViewController.h
//  douban-book
//
//  Created by xeodou on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomGridCell.h"
#import "ASIHTTPRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoadMoreTableFooterView.h"


@interface Top250ViewController : CustomViewController<GridCellItemClickDelegate, UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate, LoadMoreTableFooterDelegate>{
    
	LoadMoreTableFooterView *_loadMoreFooterView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
