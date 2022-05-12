//
//  RadioCell.m
//  
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import "RadioCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RadioCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

-(void)updateUI
{
    self.imgRadio.clipsToBounds = YES;
    self.imgRadio.layer.cornerRadius = self.imgRadio.frame.size.width / 2;
    self.imgRadio.layer.borderWidth = 1;
    self.imgRadio.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
