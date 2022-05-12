//
//  AppDelegate.m
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "Configfile.h"
#import "MenuVC.h"
#import <Chartboost/Chartboost.h>
#import "DataManager.h"

static YLRadio *sharedRadio;

@interface AppDelegate ()<ChartboostDelegate>
{
    
}
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //create Cach folder
    [DataManager creatCachFolder];
    // Initialize the Chartboost library
    [Chartboost startWithAppId:kCHARBOOST_ID
                  appSignature:kCHARBOOST_SIGNATURE
                      delegate:self];
    [Chartboost setShouldRequestInterstitialsInFirstSession:NO];
    
    //init Data
    [self initData];
    
    //create UI
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeNav"];
    
    MenuVC* leftVC = (MenuVC*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    
    MMDrawerController * sideMenuController = [[MMDrawerController alloc]
                                               initWithCenterViewController:self.mainVC
                                               leftDrawerViewController:leftVC
                                               rightDrawerViewController:nil];
    
    [sideMenuController setShowsShadow:NO];
    [sideMenuController setRestorationIdentifier:@"MMDrawer"];
    [sideMenuController setMaximumRightDrawerWidth:200.0];
    [sideMenuController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [sideMenuController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window.rootViewController = sideMenuController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    [[YLAudioSession sharedInstance] startAudioSession];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    return YES;
}


-(void)initData
{
    if ([self class] == [AppDelegate class])
    {
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSArray array], @"Favorites",
                              nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
    }
    
    NSDictionary *recorddict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray array], @"Recordings", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:recorddict];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

#pragma mark - Load

-(void)loadData
{
    //read local data
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"RadioLists"]) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"iRadio" ofType:@"plist"];
        NSArray* arrayRadios = [NSArray arrayWithContentsOfFile:plistPath];
        [[NSUserDefaults standardUserDefaults] setObject:arrayRadios forKey:@"RadioLists"];
    }
    //load data from server
    NSURL *url = [NSURL URLWithString:[kPLIST stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding]];
    NSArray* arrayRadios = [NSArray arrayWithContentsOfURL:url];
    if (arrayRadios)
    {
        //erase local data
        [[NSUserDefaults standardUserDefaults] setObject:arrayRadios forKey:@"RadioLists"];
    }
}


#pragma mark - Charboost delegate

- (void)didInitialize:(BOOL)status {
    NSLog(@"didInitialize");
    // chartboost is ready
    [Chartboost cacheRewardedVideo:CBLocationMainMenu];
    [Chartboost cacheMoreApps:CBLocationHomeScreen];
    [Chartboost cacheInterstitial:CBLocationHomeScreen];
    
    // Show an interstitial whenever the app starts up
    [Chartboost showInterstitial:CBLocationHomeScreen];
}

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
}

#pragma mark - Shared Radio

+ (YLRadio *)sharedRadio {
    if (sharedRadio) {
        return sharedRadio;
    }
    return nil;
}

+ (void)setSharedRadio:(YLRadio *)newRadio {
    if ([sharedRadio isEqual:newRadio]) {
        return;
    }
    sharedRadio = newRadio;
}
-(BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    StationPlayerVC *stationview = self.stationPlayerVC;
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:
                if(sharedRadio) {
                    if([sharedRadio isPaused]) {
                        [sharedRadio play];
                        
                    }
                }
                break;
                
            case UIEventSubtypeRemoteControlPause:
                if(sharedRadio) {
                    if([sharedRadio isPlaying]) {
                        [sharedRadio pause];
                        
                    }}
                break;
                
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [stationview actionPlayPause: nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [stationview actionPrev:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [stationview actionNext:nil];
                break;
                
            default:
                break;
        }
    }
}


@end
