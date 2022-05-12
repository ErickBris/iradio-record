//
//  MenuCell.h
//  LGSideMenuControllerDemo
//
//  Created by Friend_LGA on 26.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (assign, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet UILabel *labelMenu;
@property (strong, nonatomic) IBOutlet UIImageView *imgMenu;


@end
