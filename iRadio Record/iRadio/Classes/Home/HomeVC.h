//
//  HomeVC.h
//  
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import "BaseVC.h"
#import "RadioCell.h"

@class StationPlayerVC;

@interface HomeVC : BaseVC <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (strong, nonatomic) NSArray *arrayRadios;
@property (strong, nonatomic) StationPlayerVC *stationPlayerVC;
@property (weak, nonatomic) IBOutlet UIView *viewStations;
@property (nonatomic, strong) NSIndexPath *currentIdx;


@end
