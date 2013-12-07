//
//  ScanerViewController.m
//  douban-book
//
//  Created by xeodou on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ScanerViewController.h"
#import "BookDetailViewController.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "MobClick.h"
#import "Constants.h"

@interface ScanerViewController ()


@property (nonatomic, strong) ZBarReaderView *zbarView;
@end

@implementation ScanerViewController
@synthesize CoverView;
@synthesize editView;
@synthesize isbnEdit;
@synthesize parent;
@synthesize delegate;
@synthesize zbarView;
@synthesize bottomView;

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
    [self addZbarView];
    isbnEdit.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) addZbarView
{    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"", nil);
    zbarView = [ZBarReaderView new];
    if (IOS7_OR_LATER) {
        if (self.view.frame.size.height > 480) {
            zbarView.frame = CGRectMake(0, 0, 320, 568);
            CoverView.frame = CGRectMake(0, 0, 320, 568);
            CGRect frame = bottomView.frame;
            frame.origin.y = frame.origin.y + 88;
            bottomView.frame = frame;
        }
    } else {
        if (self.view.frame.size.height > 480) {
            zbarView.frame = CGRectMake(0, 0, 320, 568);
            CoverView.frame = CGRectMake(0, 0, 320, 568);
            CGRect frame = bottomView.frame;
            frame.origin.y = frame.origin.y + 72;
            bottomView.frame = frame;
        } else {
            zbarView.frame = CGRectMake(0, 0, 320, 460);
        }
    }
    zbarView.readerDelegate = self;
    zbarView.allowsPinchZoom = NO;
//    zbarView.scanCrop = CGRectMake(32, 133, 255, 124);
    [self.view addSubview:zbarView];
    [self.view addSubview:CoverView];
    [zbarView start];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"hud_info_complete", nil);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    // 得到扫描的条码内容
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {  // 是否QR二维码
        
    } else {
        NSLog(@"%@", symbolStr);
        [self goToSearch:symbolStr];
    }

}

- (void) viewDidAppear:(BOOL)animated
{
    if (zbarView != nil) {
//        [zbarView start];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (zbarView != nil) {
        [zbarView stop];
    }
}

- (void) goToSearch:(NSString*)str
{
    if(delegate != nil){
        [[self delegate] scanSuccess:str];
        [self dismissModalViewControllerAnimated: NO];
    }
}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    NSLog(@"%@", reader);
}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    NSLog(@"%@", self.view);
////    [UIApplication sharedApplication].statusBarHidden = NO;
//}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self setCoverView:nil];
    [self setZbarView:nil];
    [self setDelegate:nil];
    [self setParent:nil];
    [self setIsbnEdit:nil];
    [self setEditView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.origin.y = -(self.editView.frame.size.height - keyboardTop);
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    editView.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    editView.frame = self.view.bounds;
    
    [UIView commitAnimations];
}

#pragma uitextfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 13){
        return NO; // return NO to not change text
    }
    return YES;
}

- (void) clearSubviews
{
    for (UIView *v in [self.view subviews]) {
        [v removeFromSuperview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"scanerviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"scannerviewcontroller"];
}  

- (IBAction)closeBtnClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)editChangeclick:(id)sender {
    [zbarView stop];
    [self clearSubviews];
    [self.view addSubview:editView];
    [isbnEdit becomeFirstResponder];
}

- (IBAction)scanChangeClick:(id)sender {
    [isbnEdit resignFirstResponder];
    [self clearSubviews];
    [self addZbarView];
}

- (IBAction)searchClick:(id)sender {
    if ([isbnEdit text] == nil) {
        return;
    }
    if([[isbnEdit text] length] == 10 || [[isbnEdit text] length] == 13){
        [self goToSearch:[isbnEdit text]];
    } else {
        [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_isbn_length_error", nil)];
        return;
    }
}
@end
