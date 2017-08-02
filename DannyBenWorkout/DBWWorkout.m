//
//  DBWWorkout.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
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
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Deadlifts"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Pullups"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Barbell rows"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Chin ups"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Seated rows"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Dumbbell curls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hammer curls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Face pulls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks"]];


    } else if (workoutTemplate == DBWWorkoutPush1) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Bench press"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Overhead press"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Incline dumbbell bench"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Narrow grip bench"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Triceps pushdown"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Overhead tricep ext."]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Lat raises"]];


    } else if (workoutTemplate == DBWWorkoutLegs1) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Squat"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Romanian deadlift"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Leg press"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Leg curls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Calf raises"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks"]];

    } else if (workoutTemplate == DBWWorkoutPull2) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Barbell rows"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Chinups"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Seated rows"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Pullups"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Face pulls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hammer curls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Dumbbell Curls"]];

    } else if (workoutTemplate == DBWWorkoutPush2) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Overhead press"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Barbell bench"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Incline dumbbell bench"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Narrow grip bench"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Triceps pushdown"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Overhead tricep ext."]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Lat raises"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks"]];

    } else if (workoutTemplate == DBWWorkoutLegs2Pull3) {
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Squat"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Romanian deadlift"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Leg press"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Leg curls"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Calf raises"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Pullups"]];
        [workout.exercises addObject:[DBWExercise exerciseWithName:@"Chinups"]];

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
