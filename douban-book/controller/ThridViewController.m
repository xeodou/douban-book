//
//  ThridViewController.m
//  douban-book
//
//  Created by xeodou on 12-12-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThridViewController.h"
#import "MyReadCell.h"
#import "PrettyDrawing.h"
#import "UtilHelper.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "DOUUser.h"
#import "UserDB.h"
#import "MBProgressHUD.h"
#import "BookResultViewController.h"
#import "AnimationViewController.h"
#import "MobClick.h"

@interface ThridViewController ()


@property (nonatomic, strong) NSArray *array;
@property (nonatomic) BOOL login;
@property (nonatomic, strong) DOUUser *douUser;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) int selected;
@end

@implementation ThridViewController
@synthesize mTableview;
@synthesize tableHeaderView;
@synthesize avatar;
@synthesize name;
@synthesize intro;
@synthesize array;
@synthesize login;
@synthesize douUser;
@synthesize status;
@synthesize selected;

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
}

- (void) initData
{
    [mTableview setDelegate:self];
    [mTableview setDataSource:self];
    [self.navigationItem setTitle:@"我读"];
    array = [[NSArray alloc] initWithObjects:@"我读",@"想读", @"在读", @"我的笔记", @"TOP250", nil];

}

- (void) updateHeader
{
    if (login) {
        [self customNav];
        UserDB *db = [[UserDB alloc] init];
        douUser = [db getUser];
        [db close];
        if(douUser){
            [avatar setImageWithURL:[NSURL URLWithString:douUser.avatar] placeholderImage:[UIImage imageNamed:@"myread_avatar_null.png"]];
            [name setText:douUser.name];
            [intro setText:douUser.desc];
        }
    }
}

- (void) customNav
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 22, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_logout_n.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_logout_p.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item2.width = 10;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:item2, item, nil]];
}

- (void)logout:(id)sender
{
    [self showAlert:NSLocalizedString(@"alert_msg_logout", nil)];
}

- (void) showAlert:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title_info", nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"alert_btn_cancel", nil) otherButtonTitles:NSLocalizedString(@"alert_btn_ok", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UserDB *db = [[UserDB alloc] init];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"hud_info_logout", nil);
        if ([db deleteUser]) {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
            self.navigationItem.rightBarButtonItems = nil;
            login = NO;
            [mTableview reloadData];
        } else {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = NSLocalizedString(@"hud_info_book", nil);
        }
        [db close];
        [self performSelector:@selector(hiddenHUD) withObject:nil afterDelay:0.5];
    }
}

- (void) hiddenHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [tableHeaderView setHidden:!login];
    return tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return login ? tableHeaderView.frame.size.height : 0;
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
    MyReadCell *cell = (MyReadCell*)[tableView dequeueReusableCellWithIdentifier:@"myReadCell"];
    [cell.label setText:[array objectAtIndex:indexPath.row]];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
    [v setBackgroundColor:[UIColor colorWithHex:0xedf4ed]];
    [cell setSelectedBackgroundView:v];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 4){
        [self performSegueWithIdentifier:@"T250" sender:self];
    } else {
        selected = indexPath.row;
        if(!login){
            [self performSegueWithIdentifier:@"readLogin" sender:self];
            return;
        }
        [self getBook:indexPath.row];
    }
    [self performSelector:@selector(deselect:) withObject:nil];

}

- (void) getBook:(NSInteger)row
{
    if (row <= 2) {
        switch (row) {
            case 0:
                status = @"read";
                break;
            case 1:
                status = @"wish";
                break;
            case 2:
                status = @"reading";
                break;
        }
        [self performSegueWithIdentifier:@"readbook" sender:self];
    } else {
        [self performSegueWithIdentifier:@"bookanimation" sender:self];
    }
}

- (void) islogin:(BOOL)isLogin
{
    login = isLogin;
    if (isLogin) {
        [self updateHeader];
        [mTableview reloadData];
        [self getBook:selected];
        [self performSelector:@selector(deselect:) withObject:nil];
        return;
    }
    [self performSelector:@selector(deselect:) withObject:nil];
    NSLog(@"%d", isLogin);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"readLogin"]) {
        LoginViewController *fc = (LoginViewController*)[segue destinationViewController];
        fc.delegate = self;
    } else if([[segue identifier] isEqual:@"readbook"]){
        BookResultViewController *fc = (BookResultViewController*)[segue destinationViewController];
        fc.status = status;
        fc.uid = douUser.uid;
        fc.keyword = [array objectAtIndex:selected];
    } else if([[segue identifier] isEqual:@"bookanimation"]){
        AnimationViewController *fc = (AnimationViewController*)[segue destinationViewController];
        fc.uid = douUser.uid;
        fc.title = [NSString stringWithFormat:@"%@的读书笔记", douUser.name];
    }
}

- (void)viewDidUnload
{
    [self setMTableview:nil];
    [self setArray:nil];
    [self setDouUser:nil];
    [self setStatus:nil];
    [self setTableHeaderView:nil];
    [self setAvatar:nil];
    [self setName:nil];
    [self setIntro:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) deselect:(id)sender
{
    [self.mTableview deselectRowAtIndexPath:[self.mTableview indexPathForSelectedRow] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    login = [UtilHelper isLogin];
    [self updateHeader];
    if (login) {
        [mTableview reloadData];
    }
    [self.parentViewController.navigationItem setTitleView:nil];
    [self.parentViewController.navigationItem setTitle:@"我读"];
    [MobClick beginLogPageView:@"thirdviewcontroller"];
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"thirdviewcontroller"];
}  
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goToMyDouban:(id)sender {
    if (douUser.alt != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:douUser.alt]];
    }
}
@end
