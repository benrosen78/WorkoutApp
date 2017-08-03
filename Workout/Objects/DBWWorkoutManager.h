//
//  DBWWorkoutManager.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/30/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBWWorkout;

@interface DBWWorkoutManager : NSObject

+ (void)directoryInitialization;

+ (void)saveWorkout:(DBWWorkout *)workout;

+ (NSArray <DBWWorkout *> *)allWorkouts;

+ (DBWWorkout *)workoutForDay:(NSDate *)date;

+ (DBWWorkout *)workoutForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;

@end
