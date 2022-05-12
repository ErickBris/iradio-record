//
//  FavoritesVC.m
//  
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import "FavoritesVC.h"
#import "SCLAlertView.h"
#import "Configfile.h"
#import "RadioCell.h"
#import "UIImageView+WebCache.h"

@implementation FavoritesVC

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.shouldShowMenu = YES;
    self.headerTitle = @"Favorites";

    return self;
}

- (void)viewDidLoad
{
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
    [self updateData];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.mArrayFavourites count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioCell *cell = (RadioCell *)[self.tableView dequeueReusableCellWithIdentifier:@"RadioCell"];
    [cell updateUI];
    NSDictionary *item = self.mArrayFavourites [indexPath.row];
    [cell.imgRadio sd_setImageWithURL:[NSURL URLWithString:[item objectForKey:@"image"]] placeholderImage:nil];

    cell.titleLabel.text = [item valueForKey:@"name"];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"desc"]];
    
    
    return cell;
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:143.0/255.0 blue:219.0/255.0 alpha:1.0]];
    cell.titleLabel.textColor = kSTColor;
    NSDictionary *object = self.mArrayFavourites[indexPath.row];

    if (!self.stationPlayerVC) {
        self.stationPlayerVC =
        [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"StationPlayerVC"];
        self.stationPlayerVC.parentVC = self;
        self.stationPlayerVC.delegate = self;
        self.stationPlayerVC.stations = self.mArrayFavourites;
        self.stationPlayerVC.detailItem = object;
        [self.stationPlayerVC updateData];
        [self.viewStations addSubview:self.stationPlayerVC.view];
    }
    else{
        self.stationPlayerVC.stations = self.mArrayFavourites;
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
}

#pragma mark - Station Delegate

-(void)updateData
{
    self.mArrayFavourites=  [[NSMutableArray alloc] initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"]];
    if (!self.mArrayFavourites || self.mArrayFavourites.count == 0) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:knofavorite subTitle:knofavorites closeButtonTitle:kclose duration:0.0f];
    }
    [self.tableView reloadData];
    
}

@end
