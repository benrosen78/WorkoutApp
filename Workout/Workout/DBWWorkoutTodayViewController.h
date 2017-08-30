//
//  DBWWorkoutTodayViewController.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBWCustomizeWorkoutPlanViewController.h"

@class DBWWorkout;

@interface DBWWorkoutTodayViewController : DBWCustomizeWorkoutPlanViewController

@property (strong, nonatomic) DBWWorkout *workout;

@end
