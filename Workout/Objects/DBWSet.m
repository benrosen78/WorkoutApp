//
//  DBWSet.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWSet.h"

@implementation DBWSet

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _reps = [aDecoder decodeIntegerForKey:@"reps"];
        _weight = [aDecoder decodeFloatForKey:@"weight"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_reps forKey:@"reps"];
    [aCoder encodeFloat:_weight forKey:@"weight"];
}

@end
