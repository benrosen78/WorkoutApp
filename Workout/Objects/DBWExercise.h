//
//  DBWExercise.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class DBWSet, DBWWorkout;

RLM_ARRAY_TYPE(DBWSet)

@interface DBWExercise : RLMObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) RLMArray <DBWSet> *sets;

@property (nonatomic) NSInteger baseNumberOfSets;

+ (instancetype)exerciseWithName:(NSString *)name baseNumberOfSets:(NSInteger)numberOfSets;

@end
