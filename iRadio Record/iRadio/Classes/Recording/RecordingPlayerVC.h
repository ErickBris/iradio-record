//
//  RecordingPlayerVC.h
//  iRadio
//
//  Created by Bendnaiba Mohamed on 10/6/14.
//  Copyright (c) 2014 Bendnaiba Mohamed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>


@interface RecordingPlayerVC : BaseVC <AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate> {

}

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (nonatomic, retain) IBOutlet UIButton * btnShare;
@property (nonatomic, retain) IBOutlet UILabel *labelTotalTime;
@property (nonatomic, retain) IBOutlet UILabel *labelCurrentTime;
@property (strong, nonatomic) IBOutlet UISlider *sliderBar;
@property (weak, nonatomic) IBOutlet UIView *viewPulse;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (nonatomic, strong) id detailItem;
@property (nonatomic,retain) AVAudioPlayer *recordingplayer;
@property (nonatomic, retain) NSTimer *updateTimer;





- (IBAction)actionPlayPause:(id)sender;
- (IBAction)actionStop:(id)sender;
- (IBAction)progressSliderMoved:(UISlider*)sender;
- (IBAction)shareEmail:(id)sender;





@end
