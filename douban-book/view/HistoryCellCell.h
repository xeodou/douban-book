//
//  HistoryCellCell.h
//  douban-book
//
//  Created by xeodou on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryDeleteDelegate <NSObject>

- (void)click:(NSString*)name;
- (void) toSearch:(NSString*)name;
@end

@interface HistoryCellCell : UITableViewCell{
    id<HistoryDeleteDelegate> delegate;
}

@property (nonatomic, strong) id<HistoryDeleteDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel *name;

@property (nonatomic, weak) IBOutlet UIButton *delBtn;

- (IBAction) deleteClick:(id)sender;

- (IBAction) contentClick:(id)sender;

@end
