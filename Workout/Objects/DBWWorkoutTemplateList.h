//
//  DBWWorkoutTemplateList.h
//  Workout
//
//  Created by Ben Rosen on 8/13/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Realm/Realm.h>
#import "DBWWorkoutTemplate.h"

@interface DBWWorkoutTemplateList : RLMObject

@property RLMArray<DBWWorkoutTemplate> *list;

@end
