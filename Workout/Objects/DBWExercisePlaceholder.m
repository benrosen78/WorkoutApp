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

+ (NSString *)stringForExercisePlaceholderType:(DBWExercisePlaceholderType)type {
    switch (type) {
        case DBWExercisePlaceholderChestType:
            return @"Chest";
        case DBWExercisePlaceholderBackType:
            return @"Back";
        case DBWExercisePlaceholderShouldersType:
            return @"Shoulders";
        case DBWExercisePlaceholderCoreType:
            return @"Core";
        case DBWExercisePlaceholderArmsType:
            return @"Arms";
        case DBWExercisePlaceholderLegsType:
            return @"Legs";
    }
}

@end
