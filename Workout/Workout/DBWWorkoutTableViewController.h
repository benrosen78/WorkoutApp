//
//  DBWWorkoutTableViewController.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/30/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutTodayViewController.h"

@class DBWWorkout;

@interface DBWWorkoutTableViewController : DBWWorkoutTodayViewController

- (instancetype)initWithWorkout:(DBWWorkout *)workout;

@end
