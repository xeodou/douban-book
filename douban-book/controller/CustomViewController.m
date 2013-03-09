//
//  CustomViewController.m
//  douban-book
//
//  Created by xeodou on 13-1-21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.navigationItem. = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = nil;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_btn_back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_btn_back_p.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item2.width = 10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:item2, item, nil];
}

- (void) actionBack
{
    if(self.navigationController != nil){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
