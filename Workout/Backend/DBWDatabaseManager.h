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

@class RLMResults, DBWWorkout;

@interface DBWDatabaseManager : NSObject

+ (instancetype)sharedDatabaseManager;

- (DBWWorkoutTemplateList *)templateList;

- (void)saveNewWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate;

- (void)moveWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate toIndex:(NSInteger)index;

- (void)startTemplateWriting;

- (void)endTemplateWriting;

- (void)deleteWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate;

- (void)saveNewWorkout:(DBWWorkout *)workout;

- (DBWWorkout *)workoutForDateComponents:(NSDateComponents *)components;

- (DBWWorkout *)todaysWorkout;

@end

