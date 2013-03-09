//
//  SearchViewController.h
//  douban-book
//
//  Created by xeodou on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "HistoryCellCell.h"

@interface SearchViewController : CustomViewController<UITextFieldDelegate, HistoryDeleteDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *mTextField;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *keyboardbtn;
- (IBAction)hiddenKeyboard:(id)sender;

@end
