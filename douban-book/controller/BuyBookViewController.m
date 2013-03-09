//
//  BuyBookViewController.m
//  douban-book
//
//  Created by xeodou on 13-1-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BuyBookViewController.h"
#import "MBProgressHUD.h"
#import "TFHpple.h"
#import "AnimatedGif.h"
#import "MobClick.h"

#define NEWPRICE @"newprice"
#define OLDPRICE @"oldprice"
#define IMAGE @"image"
#define URL @"url"
#define MERCHANT @"merchant"

@interface BuyBookViewController ()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) MBProgressHUD *hud ;
@end

@implementation BuyBookViewController
@synthesize mtableView;
@synthesize  array;
@synthesize bookId;
@synthesize hud;

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
    [self initData];
    [self loadArray];
}

- (void) loadArray
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = NSLocalizedString(@"hud_info_load", nil);
    if(bookId == nil){
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"错误的图书Id,请返回重试！";
        return;
    }
    NSString *str = [NSString stringWithFormat:@"http://book.douban.com/subject/%@/buylinks", bookId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setCachePolicy:ASIUseDefaultCachePolicy];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlert:NSLocalizedString(@"alert_msg_buy", nil)];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    if(![self loadData:[request responseData]]){
        [self showAlert:NSLocalizedString(@"alert_msg_buy", nil)];
        return;
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [mtableView reloadData];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loadArray];
    }
}

- (void) showAlert:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title_info", nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"alert_btn_cancel", nil) otherButtonTitles:NSLocalizedString(@"alert_btn_retry", nil), nil];
    [alert show];
}

- (BOOL)loadData:(NSData*)data
{
    TFHpple *tf = [[TFHpple alloc] initWithHTMLData:data];
    NSLog(@"%@",[tf searchWithXPathQuery:@"//div[@class='indent']/table/tbody/tr"] );
    NSArray *arr = [tf searchWithXPathQuery:@"//div[@class='indent']/table"];
    if ([arr count] <= 0) {
        return NO;
    }
    TFHppleElement *elemnts = [arr objectAtIndex:0];
    arr = [elemnts children];
    NSMutableArray *merchants = [[NSMutableArray alloc] init];
    for (int i = 0, l = [arr count]; i < l ; i++) {
        if(i > 0){
            TFHppleElement *el = [arr objectAtIndex:i];
//            NSLog(@"%@", [el description]);
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSArray *a = [el childrenWithTagName:@"td"];
            for (TFHppleElement *e in a) {
                NSArray *child = [e childrenWithTagName:@"img"];
                if ([child count] > 0) {
                    NSString *str = [[(TFHppleElement*)[[e children] objectAtIndex:0] attributes] objectForKey:@"src"];
                    if( str != nil && ![str isEqual:@" "]){
                        NSLog(@"%@",  str);
                        [dic setObject:str forKey:IMAGE];
                    }
                }
                child = [e childrenWithTagName:@"a"];
                if([child count] > 0){
//                    NSLog(@"%@", [[child objectAtIndex:0] firstChild]);
                    NSString *str = [[[child objectAtIndex:0] firstChild] content];
                    if([self isPureInt:str] || [self isPureFloat:str]){
                        NSLog(@"%@", str);
                        [dic setObject:str forKey:NEWPRICE];
                        str = [[(TFHppleElement*)[child objectAtIndex:0] attributes] objectForKey:@"href"];
                        NSLog(@"%@", str);
                        [dic setObject:str forKey:URL];
                    } else if (str != nil) {
                        NSLog(@"%@", str);
                        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        if (![str isEqual:@""]) {
                            [dic setObject:str forKey:MERCHANT];
                        }
                    }
                }
                TFHppleElement *ef = [e firstTextChild];
                if ( ef != nil) {
                    NSString *str = [ef content];
                    if(str != nil || ![str isEqualToString:@" "]){
                        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                         NSLog(@"%@", str);
                        float oldprice = [[dic objectForKey:NEWPRICE] floatValue] + [str floatValue];
                        [dic setObject:[NSString stringWithFormat:@"%.2f", oldprice] forKey:OLDPRICE];
                    }
                }
            }
            [merchants addObject:dic];
        }
    }
    if(merchants == nil || [merchants count] <= 0)
        return NO;
    [array addObjectsFromArray:merchants];
    return YES;
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    int val; 
    return[scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    float val; 
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (void) initData
{
    [mtableView setDelegate:self];
    [mtableView setDataSource:self];
    array = [[NSMutableArray alloc] init];
    [self.navigationItem setTitle:@"购买图书"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyItemCell *cell = (BuyItemCell*)[tableView dequeueReusableCellWithIdentifier:@"BuyCell"];
    if ([array count] > 0) {
        NSMutableDictionary *dic = [array objectAtIndex:indexPath.row];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:[dic objectForKey:IMAGE]] delegate:self options:0 userInfo:nil success:^(UIImage *image, BOOL cache){
            if(image){
                cell.image.animationImages = [NSArray arrayWithObjects:image, nil];
                cell.image.animationDuration = 1.0f;
                cell.image.animationRepeatCount = 0;
                [cell.image startAnimating];
            }
        } failure:^(NSError *error){
            
        }];
        cell.delegate = self;
        [cell.newprice setText:[dic objectForKey:NEWPRICE]];
        [cell.oldPrice setText:[dic objectForKey:OLDPRICE]];
        [cell.merchant setText:[dic objectForKey:MERCHANT]];
        cell.url = [dic objectForKey:URL];
    }
    return cell;
}

- (void)buyItemCellBtnClick:(NSString *)str
{
    [MobClick event:@"buy"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"buyviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"buyviewcontroller"];
}  

- (void)viewDidUnload
{
    [self setArray:nil];
    [self setMtableView:nil];
    [self setBookId:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
