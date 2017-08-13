//
//  DBWExercise.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercise.h"
#import "DBWSet.h"

@implementation DBWExercise

- (instancetype)init {
    self = [super init];
    if (self) {
       // _sets = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)exerciseWithName:(NSString *)name baseNumberOfSets:(NSInteger)numberOfSets {
    DBWExercise *exercise = [[DBWExercise alloc] init];
    exercise.name = name;
    exercise.baseNumberOfSets = numberOfSets;
    return exercise;
}


@end
