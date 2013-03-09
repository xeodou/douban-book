//
//  DropedView.h
//  douban-book
//
//  Created by xeodou on 13-1-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropedItemDelegate <NSObject>

- (void) dropviewitemClick:(NSInteger)position;

@end

@interface DropedView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    id<DropedItemDelegate> delegate;
}
@property (nonatomic, strong) id<DropedItemDelegate> delegate;
@property (nonatomic, weak) IBOutlet UITableView *mtable;

- (void) setDataArray:(NSArray*)array;

@end
