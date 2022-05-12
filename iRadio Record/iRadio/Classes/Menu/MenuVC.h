//
//  MenuVC.h
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTFeedbackViewController.h"

@class RecordingVC;
@class FavoritesVC;
@class HomeVC;


@interface MenuVC : UITableViewController
{
    
}
@property(strong, nonatomic)RecordingVC* recordingVC;
@property(strong, nonatomic)FavoritesVC* favoriteVC;
@property(strong, nonatomic)HomeVC* homeVC;
@property(strong, nonatomic)CTFeedbackViewController* feedBackVC;

@property (strong, nonatomic) NSArray *arrayTitles;


@end
