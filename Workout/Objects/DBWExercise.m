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
#import "DBWWorkout.h"

@implementation DBWExercise

- (BOOL)setsCompleted {
    if ([self.sets count] == self.expectedSets) {
        for (DBWSet *set in self.sets) {
            if (!set.weight) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

+ (NSDictionary *)linkingObjectsProperties {
    return @{@"workouts": [RLMPropertyDescriptor descriptorWithClass:[DBWWorkout class] propertyName:@"exercises"]};
}
@end
