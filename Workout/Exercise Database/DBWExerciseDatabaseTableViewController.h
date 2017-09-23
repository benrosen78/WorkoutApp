//
//  DBWExerciseDatabaseTableViewController.h
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBWExerciseDatabaseDelegate.h"

@class DBWWorkoutTemplate;

@interface DBWExerciseDatabaseTableViewController : UITableViewController

@property (weak, nonatomic) id<DBWExerciseDatabaseDelegate> delegate;

@end
