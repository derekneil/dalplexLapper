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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapAction:(id)sender {
    NSLog(@"tap action");
}

- (IBAction)longPressAction:(id)sender {
    NSLog(@"long press action");
}
- (IBAction)swipeAction:(id)sender {
    NSLog(@"swipeAction");
//    if (sender == UISwipeGestureRecognizerDirectionLeft) {
//        NSLog(@"Left");
//    }
//    if(sender == UISwipeGestureRecognizerDirectionRight) {
//        NSLog(@"Right");
//    }
}
@end
