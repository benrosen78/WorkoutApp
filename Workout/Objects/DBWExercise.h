//
//  DBWExercise.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class DBWSet, DBWWorkout, DBWExercisePlaceholder;

RLM_ARRAY_TYPE(DBWSet)

@interface DBWExercise : RLMObject

@property RLMArray <DBWSet> *sets;

@property (readonly) RLMLinkingObjects *workouts;

/**
 * An "expected" set or rep is the quantity that is selected when an exercise is added to a workout or workout template
 */
@property NSInteger expectedSets, expectedReps;

@property DBWExercisePlaceholder *placeholder;

/**
 * A set is considered "completed" if it has a weight assigned to it.
 * I can't check reps because it possible for a set with zero reps.
 */
- (BOOL)setsCompleted;

@end
