//
//  CustomGridCell.h
//  douban-book
//
//  Created by xeodou on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GridCellItemClickDelegate <NSObject>

- (void) gridCellItemClick:(NSInteger)index row:(NSInteger)row;

@end

@interface CustomGridCell : UITableViewCell{
    id<GridCellItemClickDelegate> delegate;
}
@property (nonatomic, strong) id<GridCellItemClickDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView* grid_first_image;
@property (weak, nonatomic) IBOutlet UIImageView* grid_second_image;
@property (weak, nonatomic) IBOutlet UIImageView* grid_third_image;
@property (weak, nonatomic) IBOutlet UILabel* grid_first_label;
@property (weak, nonatomic) IBOutlet UILabel* grid_second_label;
@property (weak, nonatomic) IBOutlet UILabel* grid_third_label;
@property (weak, nonatomic) IBOutlet UILabel* grid_first_author;
@property (weak, nonatomic) IBOutlet UILabel* grid_second_author;
@property (weak, nonatomic) IBOutlet UILabel* grid_third_author;

@property (nonatomic) NSInteger row;
@end
