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

    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = self.workout.day;
    components.month = self.workout.month;
    components.year = self.workout.year;
    
    NSDate *dateFromComponents = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    self.title = [dateFormatter stringFromDate:dateFromComponents];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [toVC isKindOfClass:[DBWWorkoutCalendarViewController class]] ? nil : [super navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
}

@end
