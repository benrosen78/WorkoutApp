//
//  DBWCalendar.h
//  Workout
//
//  Created by Ben Rosen on 10/7/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Realm/Realm.h>

RLM_ARRAY_TYPE(DBWWorkout)

@interface DBWCalendar : RLMObject

@property RLMArray<DBWWorkout> *workouts;

@end
