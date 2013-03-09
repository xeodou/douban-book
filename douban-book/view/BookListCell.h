//
//  BookListCell.h
//  douban-book
//
//  Created by xeodou on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookRateView.h"

@interface BookListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *publisher;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet BookRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *readStatus;
@property (nonatomic, weak) IBOutlet UIView *view;
- (void) reloadViews;
- (void) setOffSet:(CGFloat) y;
@end
