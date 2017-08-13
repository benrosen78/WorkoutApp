//
//  DBWWorkoutTemplate.h
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class DBWExercise, DBWWorkoutTemplate;

RLM_ARRAY_TYPE(DBWExercise)

@interface DBWWorkoutTemplate : RLMObject

@property NSString *shortDescription;

@property RLMArray <DBWExercise> *exercises;

@property NSString *primaryKey;

@end
