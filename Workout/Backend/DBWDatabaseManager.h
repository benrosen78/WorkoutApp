//
//  DBWDatabaseManager.h
//  Workout
//
//  Created by Ben Rosen on 8/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "DBWWorkoutTemplateList.h"
#import "DBWExercise.h"

@class RLMResults, DBWWorkout, DBWExerciseDatabase, DBWExercisePlaceholder, DBWStopwatchList, DBWStopwatch;

RLM_ARRAY_TYPE(DBWExercise)

@interface DBWDatabaseManager : NSObject

+ (instancetype)sharedDatabaseManager;

- (DBWWorkoutTemplateList *)templateList;

- (void)saveNewWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate;

- (void)moveWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate toIndex:(NSInteger)index;

- (void)startTemplateWriting;

- (void)endTemplateWriting;

- (void)deleteWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate;

- (void)saveNewWorkout:(DBWWorkout *)workout;

- (DBWWorkout *)workoutForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;

- (DBWWorkout *)todaysWorkout;

- (NSArray <NSNumber *> *)yearsInDatabase;

- (void)addExercises:(RLMArray<DBWExercise> *)exercises toWorkout:(DBWWorkout *)workout;

- (void)saveNewExercisePlaceholder:(DBWExercisePlaceholder *)placeholer;

- (DBWExerciseDatabase *)allExercisePlaceholders;

- (NSArray *)pastExercisesForPlaceholder:(DBWExercisePlaceholder *)placeholder;

- (DBWStopwatchList *)stopwatchList;

- (void)saveNewStopwatch:(DBWStopwatch *)stopwatch;

@end

