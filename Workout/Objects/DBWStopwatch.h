//
//  DBWStopwatch.h
//  Workout
//
//  Created by Ben Rosen on 10/29/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Realm/Realm.h>

@interface DBWStopwatch : RLMObject

@property NSInteger minutes;

@property NSInteger seconds;

- (NSString *)formattedTimeString;

@end

RLM_ARRAY_TYPE(DBWStopwatch)
