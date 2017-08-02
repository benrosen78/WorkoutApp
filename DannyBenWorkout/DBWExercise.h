//
//  DBWExercise.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBWSet, DBWWorkout;

@interface DBWExercise : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSMutableArray <DBWSet *> *sets;

@property (weak, nonatomic) DBWWorkout *workout;

+ (instancetype)exerciseWithName:(NSString *)name;

@end
