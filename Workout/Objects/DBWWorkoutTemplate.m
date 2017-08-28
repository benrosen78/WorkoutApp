//
//  DBWWorkoutTemplate.m
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutTemplate.h"
#import "DBWExercise.h"

@implementation DBWWorkoutTemplate

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

+ (NSDictionary *)defaultPropertyValues {
    return @{@"selectedColorIndex": @0};
}

@end
