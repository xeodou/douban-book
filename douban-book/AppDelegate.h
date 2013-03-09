//
//  AppDelegate.h
//  douban-book
//
//  Created by xeodou on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>{
    Reachability *hostReach;
}

@property (strong, nonatomic) UIWindow *window;

@end
