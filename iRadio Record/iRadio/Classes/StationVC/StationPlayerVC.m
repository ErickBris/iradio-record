
//  iRadio
//
//  Created by Bendnaiba Mohamed on 11/14/12.
//  Copyright (c) 2012 iRadio. All rights reserved.
//

#import "StationPlayerVC.h"
#import <Social/Social.h>
#import "Configfile.h"
#import "SCLAlertView.h"
#import "UIImageView+WebCache.h"
#import "DataManager.h"
#import "iRadio-Swift.h"
#import "AppDelegate.h"

@interface StationPlayerVC ()
{
    
    BOOL _interruptedDuringPlayback;
    
}
@property (nonatomic)           BOOL     playerActive;

@end

@implementation StationPlayerVC

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.radio = [AppDelegate sharedRadio];
        [[YLAudioSession sharedInstance] addDelegate:self];
        self.shouldShowFavorite = YES;
    }
    return self;
}

//dealloc

- (void)dealloc {
    [[YLAudioSession sharedInstance] removeDelegate:self];
    [self.radio setDelegate:nil];
}

//when favourite button tapped
-(IBAction)favouritebuttontapped:(id)sender
{
    
    NSArray* favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"];
    if ([favorites containsObject:self.detailItem])
    {
        NSMutableArray* newArray = [NSMutableArray arrayWithArray:favorites];
        [newArray removeObject:self.detailItem];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"Favorites"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showNotice:self.parentVC title:kremovefav subTitle:kremovemsg closeButtonTitle:kclose duration:2.0];
    }
    else
    {
        
        NSMutableArray* newArray = [NSMutableArray arrayWithArray:favorites];
        [newArray addObject:self.detailItem];
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"Favorites"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showSuccess:self.parentVC title:kaddedfav subTitle:kaddmsg closeButtonTitle:kclose duration:2.0];
    }
    
    [self updateFavoriteButton];
}

- (void)updateFavoriteButton
{
    NSMutableArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"Favorites"];
    if ([favorites containsObject:self.detailItem])
        [self.btnFavorite setImage:[UIImage imageNamed:@"removefavorite.png"] forState:UIControlStateNormal];
    
    else
        [self.btnFavorite setImage:[UIImage imageNamed:@"addfavorite.png"] forState:UIControlStateNormal];
    
    if (self.delegate) {
        [self.delegate updateData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelDataRadio.marqueeType = MLContinuous;
    self.labelDataRadio.animationCurve = UIViewAnimationOptionCurveLinear;
    self.labelDataRadio.continuousMarqueeExtraBuffer = 50.0f;
    [self updateFavoriteButton];
    
    self.imageViewBackground.clipsToBounds = YES;
    self.imageViewBackground.layer.cornerRadius = self.imageViewBackground.frame.size.width / 2;
    self.imageViewBackground.layer.borderWidth = 1;
    self.imageViewBackground.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self updateData];
}

-(void)updateData
{
    self.radioLabel.text = [self.detailItem objectForKey:@"name"];
    [self.imageViewBackground sd_setImageWithURL:[NSURL URLWithString:[self.detailItem objectForKey:@"image"]]
                                placeholderImage:nil];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(UIEdgeInsetsValue)]) {
        [_imageViewBackground setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateFavoriteButton];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.appDelegate setStationPlayerVC:self];
    if ([self.radio isPlaying]) {
        [self.btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    else {
        [self.btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}




- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.radio && !self.playerActive) {
        [self actionPlayPause:nil];
    }
    NSArray *viewControllers = [[self navigationController] viewControllers];
    if ([[viewControllers lastObject] isKindOfClass:[StationPlayerVC class]]) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];

    
}

#pragma mark - Actions


#pragma mark -
#pragma mark Instance Methods
- (void)beginInterruption {
    if(self.radio == nil) {
        return;
    }
    
    if([self.radio isPlaying]) {
        _interruptedDuringPlayback = YES;
        [self.radio pause];
    }
}

- (void)endInterruptionWithFlags:(NSUInteger)flags {
    if(self.radio == nil) {
        return;
    }
    
    if(_interruptedDuringPlayback && [self.radio isPaused]) {
        [self.radio play];
    }
    
    _interruptedDuringPlayback = NO;
}

- (void)headphoneUnplugged {
    if(self.radio == nil) {
        return;
    }
    
    if([self.radio isPlaying]) {
        [self.radio pause];
    }
}


#pragma mark - Setters

- (void)setDetailItem:(id)detailItem {
    if ([detailItem isEqual:_detailItem]) {
        return;
    }
    _detailItem = detailItem;
    
    [self playRadio];
}

#pragma mark - Radio Kit interaction

- (void)playRadio {
    if (![[AppDelegate sharedRadio] isPlaying]) {
        [[AppDelegate sharedRadio] shutdown];
    }
    if(self.radio) {
        [self actionStop:nil];
    }
    [self.btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.appDelegate setStationPlayerVC:self];
    NSString* urlRadio = [_detailItem objectForKey:@"url"];
    
    if([urlRadio hasPrefix:@"mms"]) {
        self.radio = [[YLMMSRadio alloc] initWithURL:[NSURL URLWithString:urlRadio]];
    } else {
        self.radio = [[YLHTTPRadio alloc] initWithURL:[NSURL URLWithString:urlRadio]];
    }
    
    if(self.radio) {
        [AppDelegate setSharedRadio:self.radio];
        [self.radio setDelegate:self];
        [self.radio play];
    } else {
        [self.btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.appDelegate setStationPlayerVC:nil];
    }
    [self.indicator startAnimating];
    [self animatePulse:self.view.frame aboveView:self.viewPulse];
}


#pragma mark -
#pragma mark MMSRadioDelegate Methods

- (void)radioStateChanged:(YLRadio *)radio {
    YLRadioState state = [self.radio radioState];
    switch (state) {
        case kRadioStateConnecting:
        case kRadioStateBuffering:
            self.playerActive = NO;
            self.btnPlay.enabled = NO;
            break;
        case kRadioStatePlaying:
        case kRadioStateStopped:
        case kRadioStateError:
            self.playerActive = YES;
            self.btnPlay.enabled = YES;
            break;
        default:
            break;
    }
    if(state == kRadioStateConnecting) {
        [_btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.appDelegate setStationPlayerVC:self];
        [_btnPlay setEnabled:NO];
        [self.btnRecord setEnabled:NO];
    } else if(state == kRadioStateBuffering) {
        [_btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.appDelegate setStationPlayerVC:self];
        [_btnPlay setEnabled:YES];
        [self.btnRecord setEnabled:NO];
    } else if(state == kRadioStatePlaying) {
        [self.indicator stopAnimating];
        [_btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.appDelegate setStationPlayerVC:self];
        [_btnPlay setEnabled:YES];
        [self.btnRecord setEnabled:YES];
    } else if(state == kRadioStateStopped) {
        [_btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.appDelegate setStationPlayerVC:self];
        [_btnPlay setEnabled:YES];
        [self.btnRecord setEnabled:NO];
    } else if(state == kRadioStateError) {
        [_btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.appDelegate setStationPlayerVC:nil];
        [_btnPlay setEnabled:YES];
        [self.btnRecord setEnabled:NO];
        
        YLRadioError error = [self.radio radioError];
        if(error == kRadioErrorPlaylistMMSStreamDetected) {
            NSURL *url = [[self.radio url] copy];
            [self.radio shutdown];
            
            self.radio = [[YLMMSRadio alloc] initWithURL:url];
            if(self.radio) {
                [AppDelegate setSharedRadio:self.radio];
                [self.radio setDelegate:self];
                [self.radio play];
            } else {
                [self.btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
                [self.appDelegate setStationPlayerVC:nil];
            }
            
            return;
        }
        
    }
}

- (void)radioMetadataReady:(YLRadio *)radio {
    //get Radio channel MetaData
}

- (void)radioTitleChanged:(YLRadio *)radio {
    if (!self.radio) {
        return;
    }
    [self.labelDataRadio performSelectorOnMainThread:@selector(setText:) withObject:[self.radio radioTitle] waitUntilDone:YES];
    
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        
        NSString *radioinfo = [NSString stringWithFormat:@"%@-%@",[self.detailItem objectForKey:@"name"],@"iRadio Record"];
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:
                                        [UIImage imageNamed:@"logo.png"]];
        [songInfo setObject:self.radio.radioTitle forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:radioinfo forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
}

#pragma mark - Action

- (void)actionPrev:(id)sender {
    NSInteger idx = [self.stations indexOfObject:self.detailItem];
    if (idx > 0 && idx < self.stations.count && self.stations[idx-1]) {
        self.detailItem = self.stations[idx-1];
        [self updateFavoriteButton];
    }
}

- (IBAction)actionPlayPause:(id)sender {
    if (!self.radio) {
        [self playRadio];
    } else if ([self.radio isPaused]) {
        [self animatePulse:self.view.frame aboveView:self.viewPulse];
        [self.btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.appDelegate setStationPlayerVC:self];
        [self.radio play];
    } else {
        [self.radio pause];
        [self.pulseView removeFromSuperlayer];
        [self.btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.appDelegate setStationPlayerVC:nil];
        [self updateFavoriteButton];
    }
}

- (void)actionNext:(id)sender {
    NSInteger idx = [self.stations indexOfObject:self.detailItem];
    if (idx < self.stations.count-1 && self.stations[idx+1]) {
        self.detailItem = self.stations[idx+1];
        
        [self updateFavoriteButton];
    }
}

- (void)actionStop:(id)sender {
    if(self.radio) {
        [self.btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.radio shutdown];
        self.radio.delegate = nil;
        self.radio = nil;
        [AppDelegate setSharedRadio:nil];
        
        [self updateFavoriteButton];
    }
    [self.pulseView removeFromSuperlayer];
}


-(IBAction)shareon:(id)sender {
    AAShareBubbles *shareBubbles = [[AAShareBubbles alloc] initWithPoint:self.parentVC.view.center radius:120 inView:self.parentVC.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 40;
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    [shareBubbles show];
}

-(IBAction)recordliveradio:(id)sender {
    
    if(self.radio == nil) {
        return;
    }
    
    if(![self.radio isPlaying]) {
        return;
    }
    
    if(self.radio.isRecording) {
        self.btnRecord.selected = false;
        [self.radio stopRecording];
    } else {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd:MM:YY_HH:mm:ss:zz"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        recordedFileName = [NSString stringWithFormat:@"%@ (%@)", self.radioLabel.text, dateString];//[recordingname mutableCopy];
        NSString *saveName = [NSString stringWithFormat:@"%@_%@.%@", self.radioLabel.text, dateString,[self.radio fileExtensionHint]];
        saveName = [saveName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *path = [[DataManager savePath] stringByAppendingPathComponent:saveName];
        self.btnRecord.selected = true;
        [self.radio startRecordingWithDestination:path];
    }
    
}


#pragma mark - Share delegate

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    NSString *sharetext = [NSString stringWithFormat:@"%@ %@-",@"Listening",[self.detailItem objectForKey:@"name"]];
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *facebookView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [facebookView setInitialText:sharetext];
                [facebookView addImage:image];
                [facebookView addURL:[NSURL URLWithString:[_detailItem objectForKey:@"url"]]];
                [self presentViewController:facebookView animated:YES completion:nil];
                }
            else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showError:self.parentVC title:@""  subTitle:@"Sorry your facebook account is not available" closeButtonTitle:kclose duration:4.0];
            }
            break;
        case AAShareBubbleTypeTwitter:
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [twitter setInitialText:sharetext];
                [twitter addImage:image];
                [twitter addURL:[NSURL URLWithString:[_detailItem objectForKey:@"url"]]];
                [self presentViewController:twitter animated:YES completion:nil];
            }
            else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showError:self.parentVC title:@""  subTitle:@"Sorry your Twitter account is not available" closeButtonTitle:kclose duration:4.0];
            
            }
            break;
        default:
            break;
    }
}


-(void)aaShareBubblesDidHide {
}


#pragma mark - Recording delegate

- (void)radio:(YLRadio *)radio didStartRecordingWithDestination:(NSString *)path {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showInfo:self.parentVC title:krecordstart subTitle:krecstartmsg closeButtonTitle:kclose duration:2.0];
    
}

- (void)radio:(YLRadio *)radio didStopRecordingWithDestination:(NSString *)path {
    self.btnRecord.selected = false;
    NSString *recordname = recordedFileName;
    NSDictionary *recordingMetadata = [NSDictionary dictionaryWithObjectsAndKeys:
                                       recordname, @"name",
                                       [path lastPathComponent], @"url",
                                       nil];
    NSMutableArray* recording = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Recordings"]];
    self.mArrayRecording = [NSMutableArray arrayWithArray:recording];
    [self.mArrayRecording addObject:recordingMetadata];
    [[NSUserDefaults standardUserDefaults] setObject:self.mArrayRecording forKey:@"Recordings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showInfo:self.parentVC title:krecordfinish subTitle:krecfinmsg closeButtonTitle:kclose duration:2.0];
}

- (void)radio:(YLRadio *)radio recordingFailedWithError:(NSError *)error {
    self.btnRecord.selected = true;
    
}


#pragma mark - Autorate

-(BOOL)shouldAutorotate {
    return NO;
}



@end
