//
//  DBWWorkout.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2317 Ben Rosen. All rights reserved.
//

#import "DBWWorkout.h"
#import "DBWExercise.h"

@implementation DBWWorkout

- (instancetype)init {
    self = [super init];
    if (self) {
        _exercises = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _timestamp = [aDecoder decodeDoubleForKey:@"timestamp"];
        _exercises = [aDecoder decodeObjectForKey:@"exercises"];
        _template = [aDecoder decodeIntegerForKey:@"template"];
        
        for (DBWExercise *exercise in _exercises) {
            exercise.workout = self;
        }
    }
    return self;
}

+ (instancetype)workoutWithDate:(NSDate *)date andTemplate:(DBWWorkoutDay)workoutTemplate {
    DBWWorkout *workout = [[DBWWorkout alloc] init];
    workout.timestamp = [date timeIntervalSince1970];
    workout.template = workoutTemplate;
    
    if (workoutTemplate == DBWWorkoutPull1) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Deadlifts" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Pullups" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Barbell rows" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Chin ups" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Seated rows" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Dumbbell curls" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hammer curls" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Face pulls" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks" baseNumberOfSets:3]];


    } else if (workoutTemplate == DBWWorkoutPush1) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Bench press" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Overhead press" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Incline dumbbell bench" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Narrow grip bench" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Triceps pushdown" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Overhead tricep ext." baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Lat raises" baseNumberOfSets:5]];


    } else if (workoutTemplate == DBWWorkoutLegs1) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Squat" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Romanian deadlift" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Leg press" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Leg curls" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Calf raises" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks" baseNumberOfSets:3]];

    } else if (workoutTemplate == DBWWorkoutPull2) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Barbell rows" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Chinups" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Seated rows" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Pullups" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Face pulls" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hammer curls" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Dumbbell Curls" baseNumberOfSets:3]];

    } else if (workoutTemplate == DBWWorkoutPush2) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Overhead press" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Barbell bench" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Incline dumbbell bench" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Narrow grip bench" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Triceps pushdown" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Overhead tricep ext." baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Lat raises" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks" baseNumberOfSets:3]];

    } else if (workoutTemplate == DBWWorkoutLegs2Pull3) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Squat" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Romanian deadlift" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Leg press" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Leg curls" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Calf raises" baseNumberOfSets:3]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Pullups" baseNumberOfSets:5]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Chinups" baseNumberOfSets:3]];

    }
    for (DBWExercise *exercise in workout.exercises) {
        exercise.workout = workout;
    }
    
    return workout;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_timestamp forKey:@"timestamp"];
    [aCoder encodeObject:_exercises forKey:@"exercises"];
    [aCoder encodeInteger:_template forKey:@"template"];
}

@end
