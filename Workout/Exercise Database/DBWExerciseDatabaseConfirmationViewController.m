//
//  DBWExerciseDatabaseConfirmationViewController.m
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseDatabaseConfirmationViewController.h"
#import <CompactConstraint/CompactConstraint.h>

@interface DBWExerciseDatabaseConfirmationViewController ()

@property (strong, nonatomic) UILabel *setsLabel;

@end

@implementation DBWExerciseDatabaseConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"How many sets of this exercise will you do on this specific day?";
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:promptLabel];
    
    _setsLabel = [[UILabel alloc] init];
    _setsLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    _setsLabel.textAlignment = NSTextAlignmentCenter;
    _setsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_setsLabel];
    
    UIStepper *stepper = [[UIStepper alloc] init];
    [stepper addTarget:self action:@selector(setsStepperTapped:) forControlEvents:UIControlEventValueChanged];
    stepper.value = 3;
    stepper.stepValue = 1;
    stepper.minimumValue = 1;
    stepper.maximumValue = 50;
    stepper.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stepper];
    
    [self setsStepperTapped:stepper];

    
    [self.view addCompactConstraints:@[@"prompt.top = view.top + 60",
                                       @"prompt.left = view.left + 20",
                                       @"prompt.right = view.right - 20",
                                       @"stepper.centerX = view.centerX",
                                       @"stepper.top = prompt.bottom + 50",
                                       @"sets.bottom = stepper.top - 10",
                                       @"sets.centerX = view.centerX"]
                             metrics:nil
                               views:@{@"prompt": promptLabel,
                                       @"stepper": stepper,
                                       @"view": self.view,
                                       @"sets": _setsLabel
                                       }];
}

- (void)setsStepperTapped:(UIStepper *)sender {
    _setsLabel.text = [NSString stringWithFormat:sender.value == 1 ? @"%d set" : @"%d sets", (int)sender.value];
}

- (void)doneTapped:(UIBarButtonItem *)sender {

    
}

@end
