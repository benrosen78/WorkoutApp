//
//  DBWStopwatchList.h
//  Workout
//
//  Created by Ben Rosen on 10/29/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Realm/Realm.h>
#import "DBWStopwatch.h"

@interface DBWStopwatchList : RLMObject

@property RLMArray<DBWStopwatch> *list;

@end
