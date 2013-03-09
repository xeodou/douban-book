//
//  AppDelegate.m
//  douban-book
//
//  Created by xeodou on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DBHelper.h"
#import "MobClick.h"
#import "PrettyDrawing.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [DBHelper createTable];
    [MobClick startWithAppkey:@"51135b1c52701524db00001e" reportPolicy:BATCH channelId:@"appstore"];
    [MobClick checkUpdate];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_item_bg_s.png"]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name: kReachabilityChangedNotification 
                                               object: nil]; 
    hostReach = [Reachability reachabilityWithHostName:@"www.douban.com"];
    [hostReach startNotifier];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)reachabilityChanged:(NSNotification *)note { 
    Reachability* curReach = [note object]; 
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]); 
    NetworkStatus status = [curReach currentReachabilityStatus]; 
    
    if (status == NotReachable) { 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title_info", nil) message:NSLocalizedString(@"alert_msg_network_unable", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"alert_btn_ok", nil) otherButtonTitles: nil]; 
        [alert show]; 
    } 
} 

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
    }
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
