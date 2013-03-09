//
//  AnimationCell.h
//  douban-book
//
//  Created by xeodou on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnnotationClickDelegate <NSObject>

- (void)AnnotationClick:(NSString*)bid;

@end

@interface AnimationCell : UITableViewCell{
    id<AnnotationClickDelegate> delegate;
}

@property (nonatomic, strong) id<AnnotationClickDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *page;
@property (nonatomic, weak) IBOutlet UILabel *abstract;
@property (nonatomic, weak) IBOutlet UILabel *content;
@property (nonatomic, weak) IBOutlet UIView *bgview;
@property (nonatomic, strong) NSString *bookId;
- (void)setCOntentText:(NSString*)str;
- (void)addView;
- (void) showDrop:(BOOL)show;
- (IBAction)click:(id)sender;
@end
