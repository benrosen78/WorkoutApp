//
//  DBWWorkoutTableViewController.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/30/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutTableViewController.h"
#import "DBWWorkout.h"
#import "DBWExercise.h"
#import "DBWWorkoutPlanDayCell.h"
#import "DBWWorkoutCalendarViewController.h"

@interface DBWWorkoutTableViewController ()

@end

@implementation DBWWorkoutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerCell.alpha = 1;
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;


    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.workout.date];
    self.title = [NSString stringWithFormat:@"%lu/%lu/%lu", components.month, components.day, components.year];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [toVC isKindOfClass:[DBWWorkoutCalendarViewController class]] ? nil : [super navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
}

@end
