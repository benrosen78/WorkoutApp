//
//  DBWExercisePlaceholderCreationViewController.m
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePlaceholderCreationViewController.h"
#import "DBWExercisePlaceholderCreationMuscleSelectionViewController.h"
#import "DBWExercisePlaceholderCreationDelegate.h"
#import "DBWExercisePlaceholderCreationNamingViewController.h"

@interface DBWExercisePlaceholderCreationViewController () <DBWExercisePlaceholderCreationDelegate>

@property (nonatomic) DBWExercisePlaceholderType muscleGroup;

@property (strong, nonatomic) DBWExercisePlaceholderCreationMuscleSelectionViewController *muscleSelectionViewController;

@property (strong, nonatomic) DBWExercisePlaceholderCreationNamingViewController *namingViewController;

@end

@implementation DBWExercisePlaceholderCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 20;
    self.view.layer.maskedCorners = (kCALayerMaxXMinYCorner | kCALayerMinXMinYCorner);
    self.view.layer.masksToBounds = YES;
    
    _muscleSelectionViewController = [[DBWExercisePlaceholderCreationMuscleSelectionViewController alloc] init];
    _muscleSelectionViewController.completionDelegate = self;
    [self addChildViewController:_muscleSelectionViewController];
    _muscleSelectionViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_muscleSelectionViewController.view];
    [_muscleSelectionViewController didMoveToParentViewController:self];
    
    [_muscleSelectionViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_muscleSelectionViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_muscleSelectionViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_muscleSelectionViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    _namingViewController = [[DBWExercisePlaceholderCreationNamingViewController alloc] init];
    _namingViewController.completionDelegate = self;
    [self addChildViewController:_namingViewController];
    _namingViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_namingViewController.view];
    [_namingViewController didMoveToParentViewController:self];
    
    [_namingViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_namingViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_namingViewController.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [_namingViewController.view.leadingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;

    // if one of the sub view controllers show a keyboard, the view height will be changed here
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
}

#pragma mark - DBWExercisePlaceholderCreationDelegate

- (void)selectedMuscleGroup:(DBWExercisePlaceholderType)muscleGroup {
    NSLog(@"YES");
    _muscleGroup = muscleGroup;
    
    // remove, add to remove the old constraints
    [_muscleSelectionViewController.view removeFromSuperview];
    [self.view addSubview:_muscleSelectionViewController.view];
    
    [_namingViewController.view removeFromSuperview];
    [self.view addSubview:_namingViewController.view];

    // reconfigure
    [_muscleSelectionViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_muscleSelectionViewController.view.heightAnchor constraintEqualToConstant:self.view.frame.size.height].active = YES;
    [_muscleSelectionViewController.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [_muscleSelectionViewController.view.trailingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    
    [_namingViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_namingViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_namingViewController.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [_namingViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [self.delegate creationViewController:self changedToHeight:255];
    }];
}

- (void)exerciseNamed:(NSString *)name {
    [self.delegate creationViewController:self finishedWithMuscleGroup:_muscleGroup andExerciseName:name];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [_muscleSelectionViewController gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

#pragma mark - UIKeyboardWillChangeFrameNotification
- (void)keyboardNotification:(NSNotification *)notification {
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.delegate creationViewController:self changedToHeight:CGRectGetHeight(self.view.frame) + keyboardSize.height];
}

@end
