//
//  DBWExerciseDatabaseConfirmationViewController.m
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseDatabaseConfirmationViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWExercise.h"
#import "DBWExercisePlaceholder.h"
#import "DBWDatabaseManager.h"

@interface DBWExerciseDatabaseConfirmationViewController ()

@property (strong, nonatomic) UILabel *setsLabel, *repsLabel;

@property (nonatomic) NSInteger currentSets, currentReps;

@end

@implementation DBWExerciseDatabaseConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"How many sets/reps of this exercise will you do on this specific day?";
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:promptLabel];
    
    _setsLabel = [[UILabel alloc] init];
    _setsLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    _setsLabel.textAlignment = NSTextAlignmentCenter;
    _setsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_setsLabel];
    
    UIStepper *setsStepper = [[UIStepper alloc] init];
    [setsStepper addTarget:self action:@selector(setsStepperTapped:) forControlEvents:UIControlEventValueChanged];
    setsStepper.value = 3;
    setsStepper.stepValue = 1;
    setsStepper.minimumValue = 1;
    setsStepper.maximumValue = 50;
    setsStepper.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:setsStepper];
    
    _repsLabel = [[UILabel alloc] init];
    _repsLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    _repsLabel.textAlignment = NSTextAlignmentCenter;
    _repsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_repsLabel];
    
    UIStepper *repsStepper = [[UIStepper alloc] init];
    [repsStepper addTarget:self action:@selector(repsStepperTapped:) forControlEvents:UIControlEventValueChanged];
    repsStepper.value = 10;
    repsStepper.minimumValue = 1;
    repsStepper.maximumValue = 20;
    repsStepper.stepValue = 1;
    repsStepper.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:repsStepper];
    
    // have both labels be set to default values
    [self setsStepperTapped:setsStepper];
    [self repsStepperTapped:repsStepper];
    
    [self.view addCompactConstraints:@[@"prompt.top = view.top + 60",
                                       @"prompt.left = view.left + 20",
                                       @"prompt.right = view.right - 20",
                                       @"sets.top = prompt.bottom + 30",
                                       @"sets.centerX = view.centerX",
                                       @"setsStepper.centerX = view.centerX",
                                       @"setsStepper.top = sets.bottom + 10",
                                       @"reps.top = setsStepper.bottom + 30",
                                       @"reps.centerX = view.centerX",
                                       @"repsStepper.centerX = view.centerX",
                                       @"repsStepper.top = reps.bottom + 10"]
                             metrics:nil
                               views:@{@"prompt": promptLabel,
                                       @"setsStepper": setsStepper,
                                       @"view": self.view,
                                       @"sets": _setsLabel,
                                       @"reps": _repsLabel,
                                       @"repsStepper": repsStepper
                                       }];
}

- (void)setsStepperTapped:(UIStepper *)sender {
    _currentSets = (int)sender.value;
    _setsLabel.text = [NSString stringWithFormat:sender.value == 1 ? @"%lu set" : @"%lu sets", _currentSets];
}

- (void)repsStepperTapped:(UIStepper *)sender {
    _currentReps = (int)sender.value;
    _repsLabel.text = [NSString stringWithFormat:sender.value == 1 ? @"%lu rep" : @"%lu reps", _currentReps];
}

- (void)doneTapped:(UIBarButtonItem *)sender {
    // we now have an exercise placeholder and sets/reps, so we should make an exercise object
    
    if (!_selectedPlaceholder || !_delegate) {
        return;
    }
    
    DBWExercise *exercise = [[DBWExercise alloc] init];
    exercise.placeholder = _selectedPlaceholder;
    exercise.expectedSets = _currentSets;
    exercise.expectedReps = _currentReps;

    [_delegate finishedWithExercise:exercise];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
