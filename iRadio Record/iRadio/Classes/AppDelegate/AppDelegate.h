//
//  AppDelegate.h
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RadioTunes/RadioTunes.h>
#import "StationPlayerVC.h"
#import "MMDrawerController.h"

#define kMainViewController  (MMDrawerController *)[UIApplication sharedApplication].delegate.window.rootViewController

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *mainVC;
@property (nonatomic, retain)StationPlayerVC *stationPlayerVC;


+ (YLRadio *)sharedRadio;
+ (void)setSharedRadio:(YLRadio *)newRadio;







@end
