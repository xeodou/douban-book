//
//  ScanerViewController.h
//  douban-book
//
//  Created by xeodou on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@protocol ScanerViewDelegate <NSObject>

- (void)scanSuccess:(NSString*)result;

@end

@interface ScanerViewController : UIViewController<ZBarReaderViewDelegate, UITextFieldDelegate>{
    id<ScanerViewDelegate> delegate;
}
@property (strong, nonatomic) IBOutlet UIView *CoverView;
@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *isbnEdit;
@property (strong, nonatomic) UIViewController *parent;
@property (strong, nonatomic) id<ScanerViewDelegate> delegate;
- (IBAction)closeBtnClick:(id)sender;

- (IBAction)editChangeclick:(id)sender;
- (IBAction)scanChangeClick:(id)sender;
- (IBAction)searchClick:(id)sender;
@end
