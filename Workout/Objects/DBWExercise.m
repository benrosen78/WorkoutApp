//
//  DBWExercise.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercise.h"
#import "DBWSet.h"
#import "DBWDatabaseManager.h"

@implementation DBWExercise

+ (instancetype)exerciseWithName:(NSString *)name baseNumberOfSets:(NSInteger)numberOfSets {
    DBWExercise *exercise = [[DBWExercise alloc] init];
    exercise.name = name;
    exercise.baseNumberOfSets = numberOfSets;
    return exercise;
}

- (BOOL)setsCompleted {
    if ([self.sets count] == self.baseNumberOfSets) {
        for (DBWSet *set in self.sets) {
            if (!set.weight) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
