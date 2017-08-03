//
//  DBWExercise.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercise.h"
#import "DBWSet.h"

@implementation DBWExercise

- (instancetype)init {
    self = [super init];
    if (self) {
        _sets = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)exerciseWithName:(NSString *)name baseNumberOfSets:(NSInteger)numberOfSets {
    DBWExercise *exercise = [[DBWExercise alloc] init];
    exercise.name = name;
    exercise.baseNumberOfSets = numberOfSets;
    return exercise;
}

- (void)setBaseNumberOfSets:(NSInteger)baseNumberOfSets {
    _baseNumberOfSets = baseNumberOfSets;
    if ([_sets count] < baseNumberOfSets) {
        NSInteger originalCount = [_sets count];
        for (int i = 0; i < _baseNumberOfSets - originalCount; i++) {
            [_sets addObject:[[DBWSet alloc] init]];
        }
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _sets = [aDecoder decodeObjectForKey:@"sets"];
        _baseNumberOfSets = [aDecoder decodeIntegerForKey:@"baseNumberOfSets"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_sets forKey:@"sets"];
    [aCoder encodeInteger:_baseNumberOfSets forKey:@"baseNumberOfSets"];
}

@end
