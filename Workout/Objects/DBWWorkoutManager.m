//
//  DBWWorkoutManager.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/30/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutManager.h"
#import "DBWWorkout.h"
#import "DBWExercise.h"
#import "DBWWorkoutTemplate.h"

static NSMutableDictionary *configurationDictionary = nil;
static NSString *path = nil;

@implementation DBWWorkoutManager

+ (void)directoryInitialization {
    path = [[self documentsPath] stringByAppendingPathComponent:@"workouts.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        configurationDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"templates": [DBWWorkoutTemplate initialWorkoutTemplates], @"data": [NSMutableArray array]}];
    } else {
        configurationDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    /*configurationDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"data": [NSMutableArray array]}];
    [NSKeyedArchiver archiveRootObject:configurationDictionary toFile:path];*/
}

+ (void)saveWorkout:(DBWWorkout *)workout {
    dispatch_async(dispatch_queue_create("me.benrosen.workout.save", DISPATCH_QUEUE_SERIAL), ^{
        NSMutableArray *dataContents = [NSMutableArray arrayWithArray:configurationDictionary[@"data"]];
        DBWWorkout *possiblyExistingWorkout = [self workoutForDay:[NSDate dateWithTimeIntervalSince1970:workout.timestamp]];
        if (possiblyExistingWorkout) {
            NSInteger index = [dataContents indexOfObject:possiblyExistingWorkout];
            [dataContents replaceObjectAtIndex:index withObject:workout];
        } else {
            [dataContents addObject:workout];
        }
        configurationDictionary[@"data"] = dataContents;
        [NSKeyedArchiver archiveRootObject:configurationDictionary toFile:path];
    });
}

+ (NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}

+ (NSArray <DBWWorkout *> *)allWorkouts {
    /*NSLog(@"%@", configurationDictionary[@"data"]);
    for (DBWWorkout *w in configurationDictionary[@"data"]) {
        NSLog(@"new w");
        for (DBWExercise *e in w.exercises) {
            NSLog(@"\te: %@", e.name);
        }
    }*/
    return configurationDictionary[@"data"];
}

+ (DBWWorkout *)workoutForDay:(NSDate *)date {
    for (DBWWorkout *workout in [self allWorkouts]) {
        if ([[NSCalendar currentCalendar] isDate:date equalToDate:[NSDate dateWithTimeIntervalSince1970:workout.timestamp] toUnitGranularity:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear)]) {
            return workout;
        }
    }
    return nil;
}

+ (DBWWorkout *)workoutForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    for (DBWWorkout *workout in [self allWorkouts]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:workout.timestamp];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:date];
        if (components.day == day && components.month == month && components.year == year) {
            return workout;
        }
    }
    return nil;
}

+ (NSMutableArray <DBWWorkoutTemplate *> *)templates {
    return configurationDictionary[@"templates"];
}

+ (void)saveTemplate:(DBWWorkoutTemplate *)template {
    dispatch_async(dispatch_queue_create("me.benrosen.workout-template.save", DISPATCH_QUEUE_SERIAL), ^{
        NSMutableArray *dataContents = [NSMutableArray arrayWithArray:configurationDictionary[@"templates"]];
        if ([dataContents containsObject:template]) {
            NSInteger index = [dataContents indexOfObject:template];
            [dataContents replaceObjectAtIndex:index withObject:template];
        } else {
            [dataContents addObject:template];
        }
        configurationDictionary[@"templates"] = dataContents;
        [NSKeyedArchiver archiveRootObject:configurationDictionary toFile:path];
    });
    
}

@end
