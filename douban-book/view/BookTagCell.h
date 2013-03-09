//
//  BookTagCell.h
//  douban-book
//
//  Created by xeodou on 13-1-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagClickDelegte <NSObject>

- (void) tagClick:(NSString*)tag;

@end

@interface BookTagCell : UITableViewCell{
    id<TagClickDelegte> delegate;
}

@property (nonatomic) id<TagClickDelegte> delegate;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UIView *tagView;
@property (nonatomic, weak) IBOutlet UIView *bgView;
- (void)setTags:(NSArray*)array;
- (id) initWith:(NSArray*)array;
@end
