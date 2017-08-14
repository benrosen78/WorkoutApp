//
//  DBWWorkoutTableViewController.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/30/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutTableViewController.h"
#import "DBWWorkout.h"

@interface DBWWorkoutTableViewController ()

@end

@implementation DBWWorkoutTableViewController

- (instancetype)initWithWorkout:(DBWWorkout *)workout {
    self = [super init];
    if (self) {
        self.workout = workout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    //cell.userInteractionEnabled = NO;
    return cell;
}

@end
