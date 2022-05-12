//
//  DetailViewController.h
//  
//
//  Created by Bendnaiba Mohamed on 11/7/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "HeaderView.h"
#import "Configfile.h"

@class LFTPulseAnimation;
@class AppDelegate;

@interface BaseVC : UIViewController<HeaderViewDelegate, GADBannerViewDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(assign)BOOL shouldShowRefresh;
@property(assign)BOOL shouldShowMenu;
@property(assign)BOOL shouldShowFavorite;
@property(assign)BaseVC* parentVC;
@property(assign)BOOL shouldAddHeader;
@property(strong, nonatomic)HeaderView* headerView;
@property(strong, nonatomic)NSString* headerTitle;
@property(strong, nonatomic)LFTPulseAnimation* pulseView;
@property(strong, nonatomic) GADBannerView* adMobBannerView;
@property(assign)BOOL isDidLayout;


-(void)updateData;
-(void)animatePulse:(CGRect)frame aboveView:(UIView*)myView;
-(void)initAdMobBanner;
- (AppDelegate *)appDelegate;
@end
