//
//  AutoTagView.h
//  douban-book
//
//  Created by xeodou on 13-1-26.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoTagView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *tagsView;
- (id) initWith:(NSArray*)array;
- (void) setTags:(NSArray *)array;
@end
