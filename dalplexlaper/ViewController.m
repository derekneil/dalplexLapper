//
//  ViewController.m
//  dalplexlaper
//
//  Created by Derek Neil on 2013-11-05.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
- (IBAction)tapAction:(id)sender;
- (IBAction)longPressAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *lapDistance;
@property (weak, nonatomic) IBOutlet UISwitch *announcePace;
- (IBAction)swipeAction:(id)sender;
@property (nonatomic, assign) int laps;
@property (nonatomic, assign) float lapDistanceKM;
@property (nonatomic, assign) float totalDistanceKM;
@property (nonatomic, assign) BOOL announce;

@property (strong, nonatomic) UIView* laptapView;
@property (strong, nonatomic) UIView* settingsView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    
    //set base values for locals
    _laps = 0;
    _lapDistanceKM = 0.26;
    
    //default view already created for me
    _laptapView = self.view;
    
    //create ref to settings view
    _settingsView = [[NSBundle mainBundle] loadNibNamed:@"settings" owner:self options:nil];
}

- (IBAction)tapAction:(id)sender {
    NSLog(@"tap action");
    //increment lap counter
    _laps++;
    _lapsLabel.text = [NSString stringWithFormat:@"%d",_laps];
    _totalDistanceKM += _lapDistanceKM;
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_totalDistanceKM];
}

- (IBAction)longPressAction:(id)sender {
    NSLog(@"long press action");
    //go to settings view
    self.view = _settingsView;
}

- (IBAction)swipeAction:(id)sender {
    NSLog(@"swipeAction");
    //go back to main view
    self.view = _laptapView;
}
@end
