//
//  RateView.h
//  douban-book
//
//  Created by xeodou on 13-2-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateView : UIView
@property (weak, nonatomic) IBOutlet UIButton *oneStar;
@property (weak, nonatomic) IBOutlet UIButton *twoStar;
@property (weak, nonatomic) IBOutlet UIButton *threeStar;
@property (weak, nonatomic) IBOutlet UIButton *fourStar;
@property (weak, nonatomic) IBOutlet UIButton *fiveStar;

- (IBAction)click:(id)sender;
- (int)rate;
@end
