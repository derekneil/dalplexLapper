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
}

- (IBAction)longPressAction:(id)sender {
}
@end
