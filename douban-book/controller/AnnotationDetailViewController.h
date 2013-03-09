//
//  AnnotationDetailViewController.h
//  douban-book
//
//  Created by xeodou on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomViewController.h"
#import "DouBookAnnotation.h"

@interface AnnotationDetailViewController : CustomViewController


@property (nonatomic, strong) DouBookAnnotation *annot;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIScrollView *mSrcollview;
@end
