//
//  AddCommentViewController.m
//  douban-book
//
//  Created by xeodou on 13-1-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AddCommentViewController.h"
#import "DouQueryBook.h"
#import "GenDouService.h"
#import "DOUAPIConfig.h"
#import "UIHelper.h"
#import "MBProgressHUD.h"
#import "DouBookAnnotation.h"
#import "MobClick.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController
@synthesize mScrollview;
@synthesize contentTextView;
@synthesize chapterField;
@synthesize pageField;
@synthesize publicBtn;
@synthesize privateBtn;
@synthesize bookId;

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                     initWithTarget:self
                                    action:@selector(dismissKeyboard)];
    [tap setDelegate:self];
    [self.mScrollview addGestureRecognizer:tap];
     [mScrollview setContentSize:CGSizeMake(self.mScrollview.frame.size.width, self.mScrollview.frame.size.width + 20)];
    [chapterField setDelegate:self];
    [pageField setDelegate:self];
    [contentTextView setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // test if our control subview is on-screen
    if (self.publicBtn.superview != nil) {
        if ([touch.view isDescendantOfView:self.publicBtn] || [touch.view isDescendantOfView:self.privateBtn] ) {
            // we touched our control surface
            return NO; // ignore the touch
        }
    }
    return YES; // handle the touch
}

-(void)dismissKeyboard {
    [chapterField resignFirstResponder];
    [pageField resignFirstResponder];
    [contentTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([chapterField isFirstResponder]) {
        [pageField becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([pageField isFirstResponder]) {
        if (range.location >= 6){
            return NO; // return NO to not change text
        }
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([[contentTextView text] isEqual:@"输入内容"]) {
        [contentTextView setText:@""];
    }
    return YES;
}


- (void) addBOOkComment
{
    if ([[chapterField text] isEqual:@""] && [[pageField text] isEqual:@""]) {
        [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_mark_null", nil)];
        return;
    }
    
    if ([[contentTextView text] isEqual:@""]) {
         [UIHelper showAlert:NSLocalizedString(@"alert_title_info", nil) msg:NSLocalizedString(@"alert_msg_mark_content_null", nil)];
        return;
    }
    
    if (bookId == nil || [bookId isEqual:@""]) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableString *body = [[NSMutableString alloc] init];
    if ([chapterField text] != nil) {
        [dic setObject:[chapterField text] forKey:@"chapter"];
        [body appendFormat:@"chapter=%@", [chapterField text]];
    }
    if ([pageField text] != nil) {
        [dic setObject:[pageField text] forKey:@"page"];
//        [body appendFormat:@"page=%@", [pageField text]];
    }
    if ([privateBtn isSelected]) {
        [dic setObject:@"private" forKey:@"privacy"];
        [body appendFormat:@"privacy=%@", @"private"];
    } else if ([publicBtn isSelected]) {
        [dic setObject:@"public" forKey:@"privacy"];
        [body appendFormat:@"privacy=%@", @"public"];
    }
    [dic setObject:[contentTextView text] forKey:@"content"];
    [body appendFormat:@"content=%@", [contentTextView text]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = NSLocalizedString(@"hud_info_addAnnotation", nil);
    DOUService *service = [[[GenDouService alloc] init] genDouService];
    service.apiBaseUrlString = kHttpsApiBaseUrl;
    DOUQuery *query = [DouQueryBook addAnnotationForBook:bookId withParams:nil];
    DOUReqBlock block = ^(DOUHttpRequest *req){
        NSError *error = [req doubanError];
        if (error) {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = NSLocalizedString(@"hud_info_annotation", nil);
            [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1.0];
            return;
        }
        DouBookAnnotation *result = [[DouBookAnnotation alloc] initWithString:[req responseString]];
        if (result) {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = NSLocalizedString(@"hud_info_annotation_sucess", nil);
            [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1.0];
            [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:1.0];
        } else {
            [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1.0];
        }
    };
    [service postDic:query postBody:dic callback:block];
}

- (void)dismissSelf
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dismissHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    //    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.contentTextView.frame;
    newTextViewFrame.size.height = newTextViewFrame.size.height - keyboardRect.size.height;
    newTextViewFrame.origin.x = 2;
    newTextViewFrame.origin.y = 0;
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    contentTextView.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSLog(@"%@", animationDurationValue);
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect frame = contentTextView.frame;
    frame.origin.x = 2;
    frame.origin.y = 0;
    frame.size.height += keyboardRect.size.height;
    [contentTextView setFrame:frame];
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"addcommentviewcontroller"];
}    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"addcommentviewcontroller"];
}  
- (void)viewDidUnload
{
    [self setMScrollview:nil];
    [self setChapterField:nil];
    [self setPageField:nil];
    [self setPublicBtn:nil];
    [self setPrivateBtn:nil];
    [self setContentTextView:nil];
    [self setBookId:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeBtnClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 100) {
        if ([privateBtn isSelected]) {
            [privateBtn setSelected:NO];
            [publicBtn setSelected:YES];
        }
    } else if (btn.tag == 200) {
        if([publicBtn isSelected]){
            [privateBtn setSelected:YES];
            [publicBtn setSelected:NO];
        }
    }
}

- (IBAction)addBooKMark:(id)sender {
    [self dismissKeyboard];
    [self addBOOkComment];
}
@end
