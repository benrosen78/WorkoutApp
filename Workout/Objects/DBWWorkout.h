//
//  DBWWorkout.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBWExercise, DBWWorkoutTemplate;

@interface DBWWorkout : NSObject <NSCoding>

@property (nonatomic) NSTimeInterval timestamp;

@property (strong, nonatomic) NSMutableArray <DBWExercise *> *exercises;

+ (instancetype)todaysWorkoutWithTemplate:(DBWWorkoutTemplate *)workoutTemplate;

@end
