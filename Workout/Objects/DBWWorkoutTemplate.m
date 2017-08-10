
//
//  DBWWorkoutTemplate.m
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutTemplate.h"
#import "DBWExercise.h"

@implementation DBWWorkoutTemplate

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
        _exercises = [aDecoder decodeObjectForKey:@"exercises"];
        _shortDescription = [aDecoder decodeObjectForKey:@"shortDescription"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_exercises forKey:@"exercises"];
    [aCoder encodeObject:_shortDescription forKey:@"shortDescription"];
}

+ (NSMutableArray <DBWWorkoutTemplate *> *)initialWorkoutTemplates {
    DBWWorkoutTemplate *pull1 = [[DBWWorkoutTemplate alloc] init];
    pull1.shortDescription = @"Pull day 1 (w/ abs)";

    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Deadlifts" baseNumberOfSets:3]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Pullups" baseNumberOfSets:5]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Barbell rows" baseNumberOfSets:3]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Chin ups" baseNumberOfSets:3]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Seated rows" baseNumberOfSets:3]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Dumbbell curls" baseNumberOfSets:3]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Hammer curls" baseNumberOfSets:3]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Face pulls" baseNumberOfSets:5]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls" baseNumberOfSets:3]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises" baseNumberOfSets:3]];
    [pull1.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks" baseNumberOfSets:3]];
    
    DBWWorkoutTemplate *push1 = [[DBWWorkoutTemplate alloc] init];
    push1.shortDescription = @"Push day 1";

    [push1.exercises addObject:[DBWExercise exerciseWithName:@"Bench press" baseNumberOfSets:5]];
    [push1.exercises addObject:[DBWExercise exerciseWithName:@"Overhead press" baseNumberOfSets:3]];
    [push1.exercises addObject:[DBWExercise exerciseWithName:@"Incline dumbbell bench" baseNumberOfSets:3]];
    [push1.exercises addObject:[DBWExercise exerciseWithName:@"Narrow grip bench" baseNumberOfSets:3]];
    [push1.exercises addObject:[DBWExercise exerciseWithName:@"Triceps pushdown" baseNumberOfSets:3]];
    [push1.exercises addObject:[DBWExercise exerciseWithName:@"Overhead tricep ext." baseNumberOfSets:3]];
    [push1.exercises addObject:[DBWExercise exerciseWithName:@"Lat raises" baseNumberOfSets:5]];
    
    
    DBWWorkoutTemplate *legs1 = [[DBWWorkoutTemplate alloc] init];
    legs1.shortDescription = @"Legs day 1 (w/ abs)";

    [legs1.exercises addObject:[DBWExercise exerciseWithName:@"Squat" baseNumberOfSets:5]];
    [legs1.exercises addObject:[DBWExercise exerciseWithName:@"Romanian deadlift" baseNumberOfSets:3]];
    [legs1.exercises addObject:[DBWExercise exerciseWithName:@"Leg press" baseNumberOfSets:3]];
    [legs1.exercises addObject:[DBWExercise exerciseWithName:@"Leg curls" baseNumberOfSets:3]];
    [legs1.exercises addObject:[DBWExercise exerciseWithName:@"Calf raises" baseNumberOfSets:3]];
    [legs1.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls" baseNumberOfSets:3]];
    [legs1.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises" baseNumberOfSets:3]];
    [legs1.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks" baseNumberOfSets:3]];
    
    DBWWorkoutTemplate *pull2 = [[DBWWorkoutTemplate alloc] init];
    pull2.shortDescription = @"Pull day 2";

    [pull2.exercises addObject:[DBWExercise exerciseWithName:@"Barbell rows" baseNumberOfSets:5]];
    [pull2.exercises addObject:[DBWExercise exerciseWithName:@"Chinups" baseNumberOfSets:3]];
    [pull2.exercises addObject:[DBWExercise exerciseWithName:@"Seated rows" baseNumberOfSets:3]];
    [pull2.exercises addObject:[DBWExercise exerciseWithName:@"Pullups" baseNumberOfSets:3]];
    [pull2.exercises addObject:[DBWExercise exerciseWithName:@"Face pulls" baseNumberOfSets:5]];
    [pull2.exercises addObject:[DBWExercise exerciseWithName:@"Hammer curls" baseNumberOfSets:3]];
    [pull2.exercises addObject:[DBWExercise exerciseWithName:@"Dumbbell Curls" baseNumberOfSets:3]];
    
    DBWWorkoutTemplate *push2 = [[DBWWorkoutTemplate alloc] init];
    push2.shortDescription = @"Push day 2 (w/ abs)";

    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Overhead press" baseNumberOfSets:5]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Barbell bench" baseNumberOfSets:3]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Incline dumbbell bench" baseNumberOfSets:3]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Narrow grip bench" baseNumberOfSets:3]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Triceps pushdown" baseNumberOfSets:3]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Overhead tricep ext." baseNumberOfSets:3]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Lat raises" baseNumberOfSets:5]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Ab machine curls" baseNumberOfSets:3]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Hanging leg raises" baseNumberOfSets:3]];
    [push2.exercises addObject:[DBWExercise exerciseWithName:@"Weighted planks" baseNumberOfSets:3]];
    
    DBWWorkoutTemplate *legs2Pull3 = [[DBWWorkoutTemplate alloc] init];
    legs2Pull3.shortDescription = @"Leg day 2 (w/ pullups)";

    [legs2Pull3.exercises addObject:[DBWExercise exerciseWithName:@"Squat" baseNumberOfSets:3]];
    [legs2Pull3.exercises addObject:[DBWExercise exerciseWithName:@"Romanian deadlift" baseNumberOfSets:3]];
    [legs2Pull3.exercises addObject:[DBWExercise exerciseWithName:@"Leg press" baseNumberOfSets:3]];
    [legs2Pull3.exercises addObject:[DBWExercise exerciseWithName:@"Leg curls" baseNumberOfSets:3]];
    [legs2Pull3.exercises addObject:[DBWExercise exerciseWithName:@"Calf raises" baseNumberOfSets:3]];
    [legs2Pull3.exercises addObject:[DBWExercise exerciseWithName:@"Pullups" baseNumberOfSets:5]];
    [legs2Pull3.exercises addObject:[DBWExercise exerciseWithName:@"Chinups" baseNumberOfSets:3]];
    
    NSMutableArray <DBWWorkoutTemplate *> *templates = [NSMutableArray array];
    [templates addObjectsFromArray:@[pull1, push1, legs1, pull2, push2, legs2Pull3]];
    return templates;
}

@end
