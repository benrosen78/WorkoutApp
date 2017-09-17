//
//  DBWAnimationTransitionMemory.m
//  Workout
//
//  Created by Ben Rosen on 9/16/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWAnimationTransitionMemory.h"

@implementation DBWAnimationTransitionMemory

+ (instancetype)sharedInstance {
    static DBWAnimationTransitionMemory *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBWAnimationTransitionMemory alloc] init];
    });
    return sharedInstance;
}

@end
