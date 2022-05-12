//
//  HomeVC.m
//
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import "HomeVC.h"
#import "SCLAlertView.h"
#import "Configfile.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "StationPlayerVC.h"
#import "AppDelegate.h"

@implementation HomeVC
@synthesize tableView = _tableView;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.shouldShowMenu = YES;
    self.shouldShowRefresh = YES;
    self.headerTitle = @"Home";
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidLayoutSubviews
{
    if (!self.isDidLayout) {
        [self initAdMobBanner];
    }
    self.isDidLayout = true;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.arrayRadios = [[NSUserDefaults standardUserDefaults] objectForKey:@"RadioLists"];
    [self.tableView reloadData];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}



#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayRadios count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioCell *cell = (RadioCell *)[self.tableView dequeueReusableCellWithIdentifier:@"RadioCell"];
    [cell updateUI];
    NSDictionary *item = self.arrayRadios [indexPath.row];
    [cell.imgRadio sd_setImageWithURL:[NSURL URLWithString:[item objectForKey:@"image"]] placeholderImage:nil];
    cell.titleLabel.text = [item valueForKey:@"name"];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"desc"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIdx = indexPath;
    RadioCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:143.0/255.0 blue:219.0/255.0 alpha:1.0]];
    cell.titleLabel.textColor = kSTColor;
    NSDictionary *object = self.arrayRadios[self.currentIdx.row];
    if (!self.stationPlayerVC) {
        self.stationPlayerVC =
        [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"StationPlayerVC"];
        self.stationPlayerVC.parentVC = self;
        self.stationPlayerVC.stations = self.arrayRadios;
        self.stationPlayerVC.detailItem = object;
        [self.stationPlayerVC updateData];
        [self.viewStations addSubview:self.stationPlayerVC.view];
    }
    else{
        self.stationPlayerVC.stations = self.arrayRadios;
        self.stationPlayerVC.detailItem = object;
        [self.stationPlayerVC updateData];
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        RadioCell* cell = [tableView cellForRowAtIndexPath:currentSelectedIndexPath];
        [cell setBackgroundColor:kNBColor];
        cell.titleLabel.textColor = kNTColor;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioCell* myCell = (RadioCell*)cell;
    if (cell.isSelected == YES)
    {
        [cell setBackgroundColor:kSBColor];
        myCell.titleLabel.textColor = kSTColor;
    }
    else
    {
        [cell setBackgroundColor:kNBColor];
        myCell.titleLabel.textColor = kNTColor;
        
    }
    if([indexPath row] == 0){
        if (![[AppDelegate sharedRadio] isPlaying]) {
            [self performSelectorOnMainThread:@selector(playFirstAudio) withObject:nil waitUntilDone:true];
        }
    }
}

-(void)playFirstAudio
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}
@end
