//
//  DBWExercisePlaceholder.m
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePlaceholder.h"

@implementation DBWExercisePlaceholder

- (instancetype)init {
    self = [super init];
    if (self) {
        _primaryKey = [NSUUID UUID].UUIDString;
    }
    
    return self;
}

+ (NSString *)primaryKey {
    return @"primaryKey";
}

@end
