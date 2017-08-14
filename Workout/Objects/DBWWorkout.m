//
//  DBWWorkout.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2317 Ben Rosen. All rights reserved.
//

#import "DBWWorkout.h"
#import "DBWExercise.h"
#import "DBWWorkoutTemplate.h"

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
       //     exercise.workout = self;
        }
    }
    return self;
}

+ (instancetype)todaysWorkoutWithTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    DBWWorkout *workout = [[DBWWorkout alloc] init];
    workout.timestamp = [[NSDate date] timeIntervalSince1970];
    
    return workout;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_timestamp forKey:@"timestamp"];
    [aCoder encodeObject:_exercises forKey:@"exercises"];
    [aCoder encodeInteger:_template forKey:@"template"];
}

@end
