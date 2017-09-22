//
//  DBWExerciseDatabase.h
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Realm/Realm.h>
#import "DBWExercisePlaceholder.h"

RLM_ARRAY_TYPE(DBWExercisePlaceholder)

@interface DBWExerciseDatabase : RLMObject

@property RLMArray<DBWExercisePlaceholder> *list;

@end
