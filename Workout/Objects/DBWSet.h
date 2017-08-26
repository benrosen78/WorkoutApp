//
//  DBWSet.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Realm/Realm.h>

@interface DBWSet : RLMObject

@property NSInteger reps;

@property CGFloat weight;

@end

RLM_ARRAY_TYPE(DBWSet)

