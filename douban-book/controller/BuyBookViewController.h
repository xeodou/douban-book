//
//  BuyBookViewController.h
//  douban-book
//
//  Created by xeodou on 13-1-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomViewController.h"
#import "BuyItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ASIHTTPRequest.h"

@interface BuyBookViewController : CustomViewController<UITableViewDelegate, UITableViewDataSource, BuyItemCellBtnClickDeleagte, ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mtableView;

@property (nonatomic, strong) NSString *bookId;
@end
