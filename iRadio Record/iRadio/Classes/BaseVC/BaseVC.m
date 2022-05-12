//
//  DetailViewController.m
//  
//
//  Created by Bendnaiba Mohamed on 11/7/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "BaseVC.h"
#import "iRadio-Swift.h"
#import "AppDelegate.h"

@implementation BaseVC

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.shouldShowMenu = NO;
    self.shouldShowRefresh = NO;
    self.shouldShowFavorite = NO;
    self.shouldAddHeader = YES;
    self.isDidLayout = false;
    return self;

}


#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addHeader];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)updateData
{
}

#pragma mark - appDelegate

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark - addHeader

-(void)addHeader
{
    if (self.shouldAddHeader == YES)
    {
        if (self.headerView != nil)
        {
            [self.headerView removeFromSuperview];
            self.headerView = nil;
        }
        NSString *headerNibName = @"HeaderView";
        self.headerView = [[[NSBundle mainBundle]loadNibNamed:headerNibName owner:nil options:nil]objectAtIndex:0];
        self.headerView.delegate = self;
        self.headerView.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.headerView.frame.size.height);
        self.headerView.labelTitle.text = self.headerTitle;
        [self.view addSubview:self.headerView];
    }
}

#pragma mark - Animation

-(void)animatePulse:(CGRect)frame aboveView:(UIView*)myView
{
    if (!self.pulseView) {
        self.pulseView = [[LFTPulseAnimation alloc] initWithRepeatCount:INFINITY radius:130 position:CGPointMake(myView.frame.size.width/2, myView.frame.size.height/2)];
        self.pulseView.backgroundColor = [UIColor whiteColor].CGColor;
        self.pulseView.animationDuration = 2.0;
    }
    else
    {
        [self.pulseView removeFromSuperlayer];
    }
    [myView.layer insertSublayer:self.pulseView above:myView.layer];
}

#pragma mark - Actions

- (void)showMenu
{
    [kMainViewController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - misc
- (void)showError:(NSError *)error {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Error"
                                        message:error.description
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - AdMob Banner

-(void)initAdMobBanner
{
    self.adMobBannerView = [[GADBannerView alloc] init];
    float bannerHeight = self.view.frame.size.height * 0.088;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.adMobBannerView.adSize = GADAdSizeFromCGSize(CGSizeMake(self.view.frame.size.width, bannerHeight));
        self.adMobBannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, bannerHeight);
    }
    else{
        self.adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSizeMake(self.view.frame.size.width, bannerHeight));
        self.adMobBannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, bannerHeight);

    }
    self.adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID;
    self.adMobBannerView.rootViewController = self;
    self.adMobBannerView.delegate = self;
    // adMobBannerView.hidden = true
    [self.view addSubview:self.adMobBannerView];
    
    GADRequest* request = [[GADRequest alloc] init];
    request.testDevices = @[kGADSimulatorID];
    [self.adMobBannerView loadRequest:request];
}

// Show the banner
-(void)showBanner:(UIView*)banner {
    [UIView beginAnimations:@"showBanner" context: nil];
    banner.frame = CGRectMake(self.view.frame.size.width/2 - banner.frame.size.width/2,
                              self.view.frame.size.height - banner.frame.size.height,
                              banner.frame.size.width, banner.frame.size.height);
    [UIView commitAnimations];
    banner.hidden = false;
}

// Hide the banner
-(void)hideBanner:(UIView*)banner {
    if(banner.hidden == false){
        [UIView beginAnimations:@"hideBanner" context: nil];
        banner.frame = CGRectMake(0, self.view.frame.size.height, banner.frame.size.width, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = true;
    }
}

-(void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    [self showBanner:bannerView];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height - self.tableView.frame.origin.y - bannerView.frame.size.height);
}

-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"error Banner %@", error.description);
    [self hideBanner:bannerView];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height - self.tableView.frame.origin.y);
}


@end
