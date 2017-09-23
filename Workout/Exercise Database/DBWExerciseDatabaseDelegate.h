//
//  DBWExerciseDatabaseDelegate.h
//  Workout
//
//  Created by Ben Rosen on 9/23/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

@class DBWExercise;

@protocol DBWExerciseDatabaseDelegate

- (void)finishedWithExercise:(DBWExercise *)exercise;

@end
