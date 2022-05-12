//
//  HeaderView.h
//  Fidelio
//
//  Created by on 19/02/13.
//  Copyright (c) 2013 morge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderViewDelegate;

@protocol HeaderViewDelegate <NSObject>

@required

-(void)showMenu;

@end

@interface HeaderView : UIView{
    id<HeaderViewDelegate>delegate;
}

@property(retain)id delegate;
@property (retain, nonatomic) IBOutlet UILabel *labelTitle;
@property (retain, nonatomic) IBOutlet UIButton *buttonMenu;


- (IBAction)showMenu:(id)sender;
@end
