//
//  RecordingPlayerVC.m
//  iRadio
//
//  Created by Bendnaiba Mohamed on 4/2/14.
//  Copyright (c) 2014 Bendnaiba Mohamed. All rights reserved.
//
#import "RecordingPlayerVC.h"
#import "AppDelegate.h"
#import "SCLAlertView.h"
#import "UIImageView+WebCache.h"
#import "DataManager.h"
#import "iRadio-Swift.h"

@implementation RecordingPlayerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.detailItem && [self.detailItem isKindOfClass:[NSDictionary class]]) {
        if (self.detailItem[@"cover"]) {
            
        } else {
            
        }
        
        if ([self.detailItem objectForKey:@"name"]) {
            self.labelTitle.text = [self.detailItem objectForKey:@"name"];
        }
    }
}

-(void)updateData
{
    [self.imageViewBackground sd_setImageWithURL:[NSURL URLWithString:[self.detailItem objectForKey:@"image"]]
                                placeholderImage:nil];
}

- (void)setDetailItem:(id)detailItem {
    if ([detailItem isEqual:_detailItem]) {
        return;
    }
    _detailItem = detailItem;
    
    if (self.detailItem && [self.detailItem isKindOfClass:[NSDictionary class]]) {
        if (self.detailItem[@"cover"]) {
        } else {
        }
        
        if ([self.detailItem objectForKey:@"name"]) {
            self.labelTitle.text = [self.detailItem objectForKey:@"name"];
        }
    }
    
    [self playrecording];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([AppDelegate sharedRadio].isPlaying) {
        [[AppDelegate sharedRadio] pause];
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.recordingplayer isPlaying]) {
        [self.btnPlay setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self updateViewForPlayerInfo:self.recordingplayer];
        [self updateViewForPlayerState:self.recordingplayer];
    }
    else {
        [self.btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self actionStop:nil];
}



-(void)playrecording {
    if(self.recordingplayer) {
        [self actionStop:nil];
    }
    [self.btnPlay setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    self.labelTitle.text = [self.detailItem objectForKey:@"name"];
    NSString *fileName = [self.detailItem objectForKey:@"url"];
    NSString *filepath = [[DataManager savePath] stringByAppendingPathComponent:fileName];
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    NSError *error;
    
    self.recordingplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if(error) {
        
        [self.labelStatus setText:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        
    } else {
        
        if(self.recordingplayer) {
            [self.btnPlay setImage:[UIImage imageNamed:@"controls-pause.png"] forState:UIControlStateNormal];
            [self.labelStatus setText:@"Now Playing"];
            [self updateViewForPlayerInfo:self.recordingplayer];
            [self.recordingplayer setDelegate:self];
            [self.recordingplayer setVolume:0.5];
            [self.recordingplayer prepareToPlay];
            [self.recordingplayer play];
            [self updateViewForPlayerState:self.recordingplayer];

        }
    }
}

- (IBAction)actionStop:(id)sender {
    if(self.recordingplayer) {
        [self.btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self.recordingplayer stop];
        self.recordingplayer.delegate = nil;
        self.recordingplayer = nil;
        self.navigationItem.titleView = nil;
        self.labelTitle.text = [self.detailItem objectForKey:@"name"];
    }
}

- (IBAction)actionPlayPause:(id)sender {
    if (!self.recordingplayer) {
        [self playrecording];
        [self updateViewForPlayerState:self.recordingplayer];
    } else if (!self.recordingplayer.isPlaying) {
        [self.btnPlay setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self.labelStatus setText:@"Now Playing"];
        [self.recordingplayer play];
        [self updateViewForPlayerState:self.recordingplayer];
    } else {
        [self.recordingplayer pause];
        [self.btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self updateViewForPlayerState:self.recordingplayer];
        [self.labelStatus setText:@"Paused"];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [self.btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [player setCurrentTime:0.0];
    [self.labelStatus setText:@"Finished"];
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
    [self.labelStatus setText:[NSString stringWithFormat:@"%@", error.localizedDescription]];
    
    [self.btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
}

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)player
{
    self.labelCurrentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)player.currentTime / 60, (int)player.currentTime % 60, nil];
    self.sliderBar.value = player.currentTime;
}

- (void)updateCurrentTime
{
    [self updateCurrentTimeForPlayer:self.recordingplayer];
}

- (void)updateViewForPlayerState:(AVAudioPlayer *)player
{
    [self updateCurrentTimeForPlayer:player];
    
    if (self.updateTimer)
        [self.updateTimer invalidate];
    
    if (player.playing)
    {
        [self animatePulse:self.view.frame aboveView:self.viewPulse];

        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:player repeats:YES];
        [self.btnPlay setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.pulseView removeFromSuperlayer];
        self.updateTimer = nil;
        [self.btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
}

-(void)updateViewForPlayerInfo:(AVAudioPlayer*)player
{
    self.labelTotalTime.text = [NSString stringWithFormat:@"%d:%02d", (int)player.duration / 60, (int)player.duration % 60, nil];
    self.sliderBar.maximumValue =player.duration;
}

- (IBAction)progressSliderMoved:(UISlider *)sender
{
    self.recordingplayer.currentTime = sender.value;
    [self updateCurrentTimeForPlayer:self.recordingplayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)shareEmail:(id)sender {
    
    NSString *emailTitle =  @"Helllo";
    NSString *messageBody = @"Hi ! \n Below I send you ";
    NSString *name = [self.detailItem objectForKey:@"name"];
    NSString *filepath = [[DataManager savePath] stringByAppendingPathComponent:[self.detailItem objectForKey:@"url"]];
    NSData *myData = [NSData dataWithContentsOfFile: filepath];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc addAttachmentData:myData mimeType:@"audio/mp3" fileName:[NSString stringWithFormat:@"%@.mp3", name]];
        [self presentViewController:mc animated:YES completion:NULL];
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        NSLog(@"error %@", error.description);
    }
}

@end
