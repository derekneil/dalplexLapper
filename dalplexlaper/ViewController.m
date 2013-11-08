//
//  ViewController.m
//  dalplexlaper
//
//  Created by Derek Neil on 2013-11-05.
//  CopyLeft 2013 DKN Tech.
//

#import "ViewController.h"

@interface ViewController ()

//first view
@property (weak, nonatomic) IBOutlet UILabel *lapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
- (IBAction)tapAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *mainSwipeGesture;

//second view
@property (weak, nonatomic) IBOutlet UITextField *lapDistance;
@property (weak, nonatomic) IBOutlet UISwitch *announcePace;
- (IBAction)newLapLength:(id)sender;
- (IBAction)changeAnnouncePref:(id)sender;
- (IBAction)resetAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *settingsSwipeGesture;

//internals
@property (nonatomic, assign) int laps;
@property (nonatomic, assign) float lapDistanceKM;
@property (nonatomic, assign) int timeStamp;
@property (nonatomic, assign) float totalDistanceKM;
@property (nonatomic, assign) BOOL announce;
@property (nonatomic, assign) BOOL started;

//supporting
@property (nonatomic, strong) NSUserDefaults* userDefaults;
@property (nonatomic, strong) AVSpeechSynthesizer* speechSynthesizer;
@property (nonatomic, weak) MPMusicPlayerController* musicPlayer;
@property (nonatomic, assign) int musicPlaybackState;
- (void) playUtterance:(NSString*) utterString;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation ViewController

-(void)setStarted:(BOOL)started{
    _started = started;
    [_userDefaults setBool:started forKey:@"started"];
}

-(void)setTimeStamp:(int)timeStamp{
    _timeStamp = timeStamp;
    [_userDefaults setInteger:timeStamp forKey:@"timeStamp"];
}

-(void)setLaps:(int)laps{
    _laps = laps;
    [_userDefaults setInteger:laps forKey:@"laps"];
    _lapsLabel.text = [NSString stringWithFormat:@"%d",_laps];
}
-(void)setAnnounce:(BOOL)announce{
    _announce = announce;
    [_userDefaults setBool:announce forKey:@"announce"];
    _announcePace.on = _announce;
}
-(void)setTotalDistanceKM:(float)totalDistanceKM{
    _totalDistanceKM = totalDistanceKM;
    [_userDefaults setFloat:totalDistanceKM forKey:@"totalDistanceKM"];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_totalDistanceKM];
}
-(void)setLapDistanceKM:(float)lapDistanceKM{
    _lapDistanceKM = lapDistanceKM;
    [_userDefaults setFloat:lapDistanceKM forKey:@"lapDistanceKM"];
    _lapDistance.text = [NSString stringWithFormat:@"%d", (int)(_lapDistanceKM*1000) ];
}

-(void) viewDidDisappear:(BOOL)animated{
    [_userDefaults synchronize];
    
    // Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    // Resign as first responder
    [self resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"viewDidLoad");
    
    //load saved player
    _userDefaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              @"laps": @0,
                                                              @"totalDistanceKM":@0.0,
                                                              @"lapDistanceKM":@0.267,
                                                              @"timeStamp":@0,
                                                              @"announce":@1,
                                                              @"started":@1,
                                                              }];
    
    // Read save settings
    _laps = [_userDefaults integerForKey:@"laps"];
    _totalDistanceKM = [_userDefaults floatForKey:@"totalDistanceKM"];
    _lapDistanceKM = [_userDefaults floatForKey:@"lapDistanceKM"];
    _timeStamp = [_userDefaults integerForKey:@"timeStamp"];
    _announce = [_userDefaults boolForKey:@"announce"];
    _started = [_userDefaults boolForKey:@"started"];
    
    //setup tap view
    _lapsLabel.text = [NSString stringWithFormat:@"%d",_laps];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_totalDistanceKM];
    
    //setup settings view
    _lapDistance.text = [NSString stringWithFormat:@"%d", (int)(_lapDistanceKM*1000) ];
    
    //setup audio
    _speechSynthesizer  = [AVSpeechSynthesizer new];
    [_speechSynthesizer setDelegate:self];
    
    _announcePace.on = _announce;
    
    //setup screen colours for lap changes
    _colors = [NSArray arrayWithObjects:[UIColor grayColor], [UIColor greenColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor orangeColor], nil];
    
    //setup gesture prefs
    _mainSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    _settingsSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // Set itself as the first responder
    [self becomeFirstResponder];
    
}

//doesn't work if ipod music player is already playing, only one delegate to clicks possible
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"remote button push!");
                //Set timer, to detect two slow clicks
                //if second click
                //[tapAction:nil];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                
                break;
                
            default:
                break;
        }
    }
}


- (IBAction)tapAction:(id)sender {
    
    if(_started){
        
        //increment lap counter
        self.laps++;
        _lapsLabel.text = [NSString stringWithFormat:@"%d",_laps];
        self.totalDistanceKM += _lapDistanceKM;
        _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_totalDistanceKM];
        
        if(_announce){
            
            //calculate pace
            int lasttimeStamp = _timeStamp;
            self.timeStamp = [[NSDate new] timeIntervalSinceReferenceDate];
            float pace = ((_timeStamp - lasttimeStamp) / 60.0) / (_lapDistanceKM);
            
            NSString* announceString;
            
            //build announcement based on lap
            if(_laps%4==0){
                announceString = [NSString stringWithFormat:@"Distance, %.2f kilometers, pace, %.2f", _totalDistanceKM, pace];
            }else{
                announceString = [NSString stringWithFormat:@"Pace, %.2f", pace];
            }
            
            //play announcement
            [self playUtterance: announceString];
        }
    }
    else{ //start lap timer
        
        self.started = TRUE;
        self.timeStamp = [[NSDate new] timeIntervalSinceReferenceDate];
        
        if (_announce){
            [self playUtterance: [NSString stringWithFormat:@"Start"]];
        }
    }
    
    [self doBackgroundColorAnimation];
}

- (void) playUtterance:(NSString*) utterString{
    
    //pause any playing music player
    _musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    if(_musicPlayer){
        _musicPlaybackState = [_musicPlayer playbackState];
        [_musicPlayer pause];
    }
    
    AVSpeechUtterance* utterance = [[AVSpeechUtterance alloc ] initWithString:utterString];
    [_speechSynthesizer speakUtterance:utterance];
    
}

- (void) speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{

    if( _musicPlaybackState == 1){
        [_musicPlayer play];
    }
    
    _musicPlayer = nil;
}

- (void) doBackgroundColorAnimation {
    
    //change background colour based on lapnumber
    [UIView animateWithDuration:1.0f animations:^{
        self.view.backgroundColor = [_colors objectAtIndex: (_laps % [_colors count] )];
    }];
    
}

- (IBAction)newLapLength:(id)sender {
    self.lapDistanceKM = [_lapDistance.text intValue]/1000.0;
}

- (IBAction)changeAnnouncePref:(id)sender {
    self.announce = [sender isOn];
}

- (IBAction)resetAction:(id)sender {
    self.laps = 0;
    self.totalDistanceKM = 0;
    self.lapDistanceKM = 0.267;
    self.timeStamp = 0;
    self.started = FALSE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
