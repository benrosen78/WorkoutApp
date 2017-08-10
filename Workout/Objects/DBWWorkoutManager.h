//
//  DBWWorkoutManager.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/30/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBWWorkout, DBWWorkoutTemplate;

@interface DBWWorkoutManager : NSObject

+ (void)directoryInitialization;

+ (void)saveWorkout:(DBWWorkout *)workout;

+ (void)saveTemplate:(DBWWorkoutTemplate *)workout;

+ (void)moveTemplate:(DBWWorkoutTemplate *)workoutTemplate toIndex:(NSInteger)index;

+ (NSArray <DBWWorkout *> *)allWorkouts;

+ (DBWWorkout *)workoutForDay:(NSDate *)date;

+ (DBWWorkout *)workoutForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;

+ (NSMutableArray <DBWWorkoutTemplate *> *)templates;

+ (void)removeTemplate:(DBWWorkoutTemplate *)workoutTemplate;

@end
