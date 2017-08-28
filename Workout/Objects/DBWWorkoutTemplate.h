//
//  DBWWorkoutTemplate.h
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "DBWExercise.h"

RLM_ARRAY_TYPE(DBWExercise)

@class DBWExercise, DBWWorkoutTemplate;

@interface DBWWorkoutTemplate : RLMObject

@property NSString *shortDescription;

@property RLMArray <DBWExercise> *exercises;

@property NSString *primaryKey;

@property NSInteger selectedColorIndex;

@end

RLM_ARRAY_TYPE(DBWWorkoutTemplate)


