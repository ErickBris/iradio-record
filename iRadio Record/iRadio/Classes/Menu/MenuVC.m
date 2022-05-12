//
//  MenuVC.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "MenuVC.h"
#import "HomeVC.h"
#import "FavoritesVC.h"
#import "RecordingVC.h"
#import "MenuCell.h"
#import "AppDelegate.h"

@interface MenuVC ()

@end

@implementation MenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.tableView.backgroundColor = [UIColor clearColor];
    //self.tintColor = [UIColor whiteColor];
    
    // -----
    
    self.arrayTitles = @[@"Home",
                         @"Favorites",
                         @"Recording",
                         @"Your FeedBack",
                         @"Share"];
    
    // -----
    
    self.tableView.contentInset = UIEdgeInsetsMake(44.f, 0.f, 44.f, 0.f);
}

-(void)viewDidLayoutSubviews
{
    //self.tableView.ba = [UIImage imageNamed:@"image"];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitles.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.labelMenu.text = self.arrayTitles[indexPath.row];
    cell.imgMenu.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar-tab%d.png",indexPath.row+1]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    UIViewController* vc = nil;
    switch (indexPath.row) {
        case 0:
            if (!self.homeVC) {
                self.homeVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeNav"];
            }
            vc = self.homeVC;
            break;
        case 1:
            if (!self.favoriteVC) {
                self.favoriteVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"FavoritesNav"];
            }
            vc = self.favoriteVC;
            break;
        case 2:
            if (!self.recordingVC) {
                self.recordingVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RecordingNav"];
            }
            vc = self.recordingVC;
            break;
        case 3:
            if (!self.feedBackVC) {
                self.feedBackVC = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
                self.feedBackVC.toRecipients = @[kMAIL];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 0, 40, 30);
                [btn setTitle:@"" forState:UIControlStateNormal];
                [btn setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
                [btn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_feedBackVC];
                navigationController.navigationBar.barTintColor = [UIColor colorWithRed:247.0/255.0 green:40.0/255.0 blue:70.0/255.0 alpha:1.0];
                navigationController.navigationBar.tintColor = [UIColor whiteColor];
                navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
                self.feedBackVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
                self.feedBackVC = navigationController;
            }
            vc = self.feedBackVC;
            break;
        case 4:
        {
            NSString *stringtoshare= @"I am listening to iRadio";
            
            NSArray *activityItems = @[stringtoshare];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
            //if iPhone
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [kMainViewController presentViewController:activityVC animated:TRUE completion:nil];
                [kMainViewController closeDrawerAnimated:YES completion:nil];
            }
            //if iPad
            else {
                //UIViewController* vcShare = [UIApplication sharedApplication].keyWindow.rootViewController;
                // Change Rect to position Popover
                //UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:vcShare];
                //[popup presentPopoverFromRect:CGRectMake(vcShare.view.frame.size.width/2, vcShare.view.frame.size.height/4, 0, 0)inView:[kMainViewController centerViewController].view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            
            return;
            break;
        }
        default:
            break;
    }
    
    [kMainViewController setCenterViewController:vc withCloseAnimation:YES completion:nil];
    
}

- (void)showMenu
{
    [kMainViewController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
