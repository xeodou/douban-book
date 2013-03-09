//
//  AddCommentViewController.h
//  douban-book
//
//  Created by xeodou on 13-1-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate,UIGestureRecognizerDelegate>
- (IBAction)closeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *chapterField;
@property (weak, nonatomic) IBOutlet UITextField *pageField;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;
@property (weak, nonatomic) IBOutlet UIButton *privateBtn;
@property (nonatomic, strong) NSString *bookId;
- (IBAction)btnClick:(id)sender;
- (IBAction)addBooKMark:(id)sender;

@end
