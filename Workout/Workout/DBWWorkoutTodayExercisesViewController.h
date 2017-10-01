//
//  DBWWorkoutTodayExercisesViewController.h
//  Workout
//
//  Created by Ben Rosen on 9/2/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWWorkout, DBWWorkoutPlanDayCell;

@interface DBWWorkoutTodayExercisesViewController : UICollectionViewController <UINavigationControllerDelegate>

- (instancetype)initWithWorkout:(DBWWorkout *)workout;

@property (strong, nonatomic) DBWWorkout *workout;

@property (strong, nonatomic) DBWWorkoutPlanDayCell *headerCell;

@property (nonatomic) CGFloat headerCellAlpha;

@end
