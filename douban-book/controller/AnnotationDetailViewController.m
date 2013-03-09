//
//  AnnotationDetailViewController.m
//  douban-book
//
//  Created by xeodou on 13-2-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AnnotationDetailViewController.h"
#import "MobClick.h"

@interface AnnotationDetailViewController ()

@end

@implementation AnnotationDetailViewController
@synthesize annot;
@synthesize time;
@synthesize content;
@synthesize mSrcollview;

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
    if (annot == nil) {
        return;
    }
    if(annot.chapter != nil && ![annot.chapter isEqual:@""])
        [self.navigationItem setTitle:annot.chapter];
    else 
        [self.navigationItem setTitle:@"暂无章节名"];
    [time setText:[NSString stringWithFormat:@"%@ 写于 %@",annot.author.name, annot.time ]];
    UIFont *font = [content font];
    CGSize size = [annot.content sizeWithFont:font];
    CGRect frame = content.frame;
    float h = (size.width / frame.size.width + 1) * size.height;
    float ofh = 0;
    if (h > 480 * 5) {
        h = 480 *5;
    }
    if (h > frame.size.height) {
        ofh = h - frame.size.height;
    }
    frame.size = CGSizeMake(frame.size.width, h);
    [content setFrame:frame];
    [content setText:annot.content];
    frame = mSrcollview.frame;
    [mSrcollview setContentSize:CGSizeMake(frame.size.width, content.frame.size.height + time.frame.size.height)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"annotationdetailviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"annotationdetailviewcontroller"];
}  

- (void)viewDidUnload
{
    [self setAnnot:nil];
    [self setTime:nil];
    [self setContent:nil];
    [self setMSrcollview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
