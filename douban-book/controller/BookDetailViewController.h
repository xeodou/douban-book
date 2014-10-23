//
//  BookDetailViewController.h
//  douban-book
//
//  Created by xeodou on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOUBook.h"
#import "BookDetailHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomViewController.h"
#import "BookInfoView.h"
#import "LoginViewController.h"
#import "UAModalPanel.h"
#import "RateView.h"

@interface BookDetailViewController : CustomViewController<LoginCallDelegate>

{
    DOUBook* mdouBook;
}

@property (weak, nonatomic) IBOutlet UILabel *bookReview;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;
@property (nonatomic, retain) DOUBook* mdouBook;
@property (weak, nonatomic) IBOutlet BookDetailHeader *mDetailView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *readerStatusSege;
- (IBAction)readStatusChange:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *commentTextview;
@property (strong, nonatomic) IBOutlet BookInfoView *mbookInfoView;
@property (strong, nonatomic) IBOutlet BookInfoView *mbooAuthorInfoView;
@property (strong, nonatomic) IBOutlet UIView *mFooterView;
@property (strong, nonatomic) NSString *isbn;
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (strong, nonatomic) IBOutlet UAModalPanel *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *privateBtn;
- (IBAction)bookUserCommentClick:(id)sender;
- (IBAction)bookCommentClick:(id)sender;
- (IBAction)addBookMarkClick:(id)sender;
- (IBAction)showDialog:(id)sender;
- (IBAction)completeBtnClick:(id)sender;
- (IBAction)closebtnClick:(id)sender;
- (IBAction)privateBtnClick:(id)sender;
@end
