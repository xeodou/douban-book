//
//  BookCommentViewController.h
//  douban-book
//
//  Created by xeodou on 13-2-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomViewController.h"
#import "ASIHTTPRequest.h"
#import "LoadMoreTableFooterView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface BookCommentViewController : CustomViewController<UITableViewDataSource, UITableViewDelegate, LoadMoreTableFooterDelegate>
{
    
	LoadMoreTableFooterView *_loadMoreFooterView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *title;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
