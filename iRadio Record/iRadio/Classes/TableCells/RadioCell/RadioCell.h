//
//  RadioCell.h
//  
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgRadio;
@property (weak, nonatomic) IBOutlet UILabel *labelNB;

-(void)updateUI;

@end


