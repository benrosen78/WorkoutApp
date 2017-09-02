//
//  DBWWorkoutTodayExercisesViewController.h
//  Workout
//
//  Created by Ben Rosen on 9/2/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWWorkout;

@interface DBWWorkoutTodayExercisesViewController : UICollectionViewController

- (instancetype)initWithWorkout:(DBWWorkout *)workout;

@end
