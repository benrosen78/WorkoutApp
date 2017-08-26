//
//  DBWWorkout.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

RLM_ARRAY_TYPE(DBWExercise)

@class DBWExercise, DBWWorkoutTemplate;

@interface DBWWorkout : RLMObject

@property NSInteger day, month, year;

@property RLMArray <DBWExercise> *exercises;

@property (strong, nonatomic) DBWWorkoutTemplate *workoutTemplate;

+ (instancetype)todaysWorkoutWithTemplate:(DBWWorkoutTemplate *)workoutTemplate;

@end
