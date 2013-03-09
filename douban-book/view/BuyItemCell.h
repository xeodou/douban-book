//
//  BuyItemCell.h
//  douban-book
//
//  Created by xeodou on 13-1-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyItemCellBtnClickDeleagte <NSObject>

- (void) buyItemCellBtnClick:(NSString*)str;
@end

@interface BuyItemCell : UITableViewCell

@property (nonatomic, strong) id<BuyItemCellBtnClickDeleagte> delegate;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *newprice;
@property (nonatomic, weak) IBOutlet UILabel *oldPrice;
@property (nonatomic, weak) IBOutlet UILabel *merchant;
@property (nonatomic, strong) NSString *url;
- (IBAction)buyBtnClick:(id)sender;
@end
