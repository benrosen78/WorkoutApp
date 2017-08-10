//
//  DBWWorkoutTemplate.h
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBWExercise, DBWWorkoutTemplate;

@interface DBWWorkoutTemplate : NSObject <NSCoding>

@property (strong, nonatomic) NSString *shortDescription;

@property (strong, nonatomic) NSMutableArray <DBWExercise *> *exercises;

+ (NSMutableArray <DBWWorkoutTemplate *> *)initialWorkoutTemplates;

@end
