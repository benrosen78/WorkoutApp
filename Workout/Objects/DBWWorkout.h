//
//  DBWWorkout.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBWExercise, DBWWorkoutTemplate;

typedef NS_ENUM(NSInteger, DBWWorkoutDay) {
    DBWWorkoutPull1,
    DBWWorkoutPush1,
    DBWWorkoutLegs1,
    DBWWorkoutPull2,
    DBWWorkoutPush2,
    DBWWorkoutLegs2Pull3,
};

@interface DBWWorkout : NSObject <NSCoding>

@property (nonatomic) NSTimeInterval timestamp;

@property (strong, nonatomic) NSMutableArray <DBWExercise *> *exercises;

@property (nonatomic) DBWWorkoutDay template;

+ (instancetype)todaysWorkoutWithTemplate:(DBWWorkoutTemplate *)workoutTemplate;

@end
