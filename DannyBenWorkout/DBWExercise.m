//
//  DBWExercise.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercise.h"

@implementation DBWExercise

- (instancetype)init {
    self = [super init];
    if (self) {
        _sets = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)exerciseWithName:(NSString *)name {
    DBWExercise *excercise = [[DBWExercise alloc] init];
    excercise.name = name;
    return excercise;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _sets = [aDecoder decodeObjectForKey:@"sets"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_sets forKey:@"sets"];
}

@end
