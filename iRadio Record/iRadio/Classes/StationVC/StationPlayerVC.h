//
//  StationPlayerVC.h
//
// created by Bendnaiba Mohamed 12/12/2016
//  Copyright (c) 2014 .Bendnaiba Mohamed All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreData/CoreData.h>
#import <RadioTunes/RadioTunes.h>
#import <MessageUI/MessageUI.h>
#import "MarqueeLabel.h"
#import "AAShareBubbles.h"
#import "BaseVC.h"

@protocol StationDelegate <NSObject>
-(void)updateData;
@end



@interface StationPlayerVC : BaseVC <YLRadioDelegate,YLAudioSessionDelegate,AAShareBubblesDelegate,UIPickerViewDelegate> {
    
    NSString *recordedFileName;
}
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (nonatomic, retain) IBOutlet UIButton *btnFavorite;
@property (nonatomic, retain) IBOutlet UIButton * btnRecord;
@property (nonatomic, retain) IBOutlet UIButton * btnShare;
@property (weak, nonatomic) IBOutlet UILabel *radioLabel;
@property (strong, nonatomic) IBOutlet MarqueeLabel *labelDataRadio;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *viewPulse;
@property (weak, nonatomic) IBOutlet UIImageView *imgMask;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (nonatomic, strong) id<StationDelegate>delegate;
@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) id detailItem;
@property (nonatomic, strong) YLRadio *radio;
@property (nonatomic,retain)  NSMutableArray * mArrayRecording;


- (void)actionPrev:(id)sender;
- (void)actionNext:(id)sender;
- (void)actionStop:(id)sender;
- (IBAction)actionPlayPause:(id)sender;
- (IBAction)shareon:(id)sender;
- (IBAction)favouritebuttontapped:(id)sender;
- (IBAction)recordliveradio:(id)sender;


@end

