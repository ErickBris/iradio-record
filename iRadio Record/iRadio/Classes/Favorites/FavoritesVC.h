//
//  FavoritesVC.h
//  
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "StationPlayerVC.h"

@interface FavoritesVC : BaseVC<UITableViewDataSource,UITableViewDelegate, StationDelegate>


@property (strong, nonatomic) NSMutableArray *mArrayFavourites;
@property (strong, nonatomic) StationPlayerVC *stationPlayerVC;
@property (weak, nonatomic) IBOutlet UIView *viewStations;


@end
