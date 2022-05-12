//
//  SecondViewController.h
//  
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@class RecordingPlayerVC;

@interface RecordingVC : BaseVC <UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) NSMutableArray *mArrayRecording;
@property (weak, nonatomic) IBOutlet UIView *viewStations;
@property (strong, nonatomic) RecordingPlayerVC *recordingPlayerVC;


@end
