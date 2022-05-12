//
//  HeaderView.m
//  Fidelio
//
//  Created by on 19/02/13.
//  Copyright (c) 2013 morge. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)showMenu:(id)sender
{
    [delegate showMenu];
}


@end
