//
//  BookDetailHeader.h
//  douban-book
//
//  Created by xeodou on 13-1-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailHeader : UIView

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *originTitle;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *translator;
@property (weak, nonatomic) IBOutlet UILabel *pulisher;
@property (weak, nonatomic) IBOutlet UILabel *pulishDate;
@property (weak, nonatomic) IBOutlet UILabel *pages;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *ISBN;
@property (weak, nonatomic) IBOutlet UILabel *average;
- (void) reloadViews;
@end
