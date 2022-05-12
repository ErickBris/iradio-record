//
//  SecondViewController.m
//  
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import "RecordingVC.h"
#import "SCLAlertView.h"
#import "Configfile.h"
#import "RadioCell.h"
#import "RecordingPlayerVC.h"
#import "DataManager.h"


@implementation RecordingVC

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.shouldShowMenu = YES;
    self.headerTitle = @"Recording";

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mArrayRecording= [[NSMutableArray alloc] initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"Recordings"]];
    [self.tableView reloadData];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions


- (void)viewDidUnload {
    
    [super viewDidUnload];
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.mArrayRecording count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RadioCell *cell = (RadioCell *)[self.tableView dequeueReusableCellWithIdentifier:@"RadioCell"];
    NSDictionary *item = self.mArrayRecording [indexPath.row];
    cell.labelNB.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.titleLabel.text = [item valueForKey:@"name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    RadioCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:143.0/255.0 blue:219.0/255.0 alpha:1.0]];
    cell.titleLabel.textColor = kSTColor;
    cell.labelNB.textColor = kSTColor;
    [cell setEditing:YES animated:YES];
    
    if (!self.recordingPlayerVC) {
        self.recordingPlayerVC =
        [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"RecordingPlayerVC"];
        [self.viewStations addSubview:self.recordingPlayerVC.view];
    }
    NSDictionary *object = self.mArrayRecording[indexPath.row];
    self.recordingPlayerVC.detailItem = object;
    [self.recordingPlayerVC updateData];

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        RadioCell* cell = [tableView cellForRowAtIndexPath:currentSelectedIndexPath];
        [cell setBackgroundColor:kNBColor];
        cell.titleLabel.textColor = kNTColor;
        cell.labelNB.textColor = kNTColor;
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
        myCell.labelNB.textColor = kSTColor;
    }
    else
    {
        [cell setBackgroundColor:kNBColor];
        myCell.titleLabel.textColor = kNTColor;
        myCell.labelNB.textColor = kNTColor;
    }
}


#pragma mark - Segue

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *filename = [[self.mArrayRecording objectAtIndex:indexPath.row] objectForKey:@"name"];
        NSString *path = [[DataManager savePath] stringByAppendingPathComponent:filename];
        NSError *error;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];	//Delete it
            
            
        }
        [self.mArrayRecording removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
        
        NSMutableArray *newarray = [self.mArrayRecording mutableCopy];
        [[NSUserDefaults standardUserDefaults] setObject:newarray forKey:@"Recordings"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
    }
    
}


@end

