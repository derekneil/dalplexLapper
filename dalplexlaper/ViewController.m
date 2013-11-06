//
//  ViewController.m
//  dalplexlaper
//
//  Created by Derek Neil on 2013-11-05.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (int) random:(int)min :(int)max;

@property (weak, nonatomic) IBOutlet UILabel *lapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
- (IBAction)tapAction:(id)sender;
- (IBAction)swipeToSettingsAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *lapDistance;
@property (weak, nonatomic) IBOutlet UISwitch *announcePace;
- (IBAction)swipeAction:(id)sender;

@property (nonatomic, assign) int laps;
@property (nonatomic, assign) float lapDistanceKM;
@property (nonatomic, assign) float totalDistanceKM;
@property (nonatomic, assign) BOOL announce;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    
    //set base values for locals
    _lapDistanceKM = 0.26;
    
    _lapsLabel.text = [NSString stringWithFormat:@"%d",_laps];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_totalDistanceKM];
}

- (IBAction)tapAction:(id)sender {
    NSLog(@"tap action");
    //increment lap counter
    _laps++;
    _lapsLabel.text = [NSString stringWithFormat:@"%d",_laps];
    _totalDistanceKM += _lapDistanceKM;
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_totalDistanceKM];
    
    [self doBackgroundColorAnimation];
}

//adapted from http://stackoverflow.com/questions/6241655/uiview-backgroundcolor-color-cycle
- (void) doBackgroundColorAnimation {
    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor orangeColor], nil];
    
    [UIView animateWithDuration:2.0f animations:^{
        
        self.view.backgroundColor = [colors objectAtIndex:[self random:0:4]];
    }];
    
}
- (int) random:(int)min :(int)max {
    return ( (arc4random() % (max-min+1)) + min );
}


- (IBAction)swipeToSettingsAction:(id)sender {
    NSLog(@"swipe to settings action");
    //go to settings view
}

- (IBAction)swipeAction:(id)sender {
    NSLog(@"swipeAction");
    //go back to main view
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //passing values to a new instance of itself is rediculous!
    ViewController *destVC = [segue destinationViewController];
    destVC.laps = _laps;
    destVC.totalDistanceKM = _totalDistanceKM;
    destVC.lapDistanceKM = _lapDistanceKM;
    destVC.announce = _announce;
}


@end
