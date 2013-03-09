//
//  AnimationViewController.h
//  douban-book
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AnimationCell.h"
#import "LoadMoreTableFooterView.h"

@interface AnimationViewController : CustomViewController<UITableViewDataSource, UITableViewDelegate, AnnotationClickDelegate, LoadMoreTableFooterDelegate>
{
    
	LoadMoreTableFooterView *_loadMoreFooterView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableview;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *title;

@end
