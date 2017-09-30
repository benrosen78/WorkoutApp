//
//  DBWWorkout.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2317 Ben Rosen. All rights reserved.
//

#import "DBWWorkout.h"
#import "DBWExercise.h"
#import "DBWWorkoutTemplate.h"
#import "DBWDatabaseManager.h"
#import "DBWDatabaseManager.h"

@implementation DBWWorkout

+ (instancetype)todaysWorkoutWithTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    DBWWorkout *workout = [[DBWWorkout alloc] init];
    [[DBWDatabaseManager sharedDatabaseManager] addExercises:workoutTemplate.exercises toWorkout:workout];
    
    workout.selectedColorIndex = workoutTemplate.selectedColorIndex;
    workout.comments = workoutTemplate.shortDescription;
    workout.templateDay = [[DBWDatabaseManager sharedDatabaseManager].templateList.list indexOfObject:workoutTemplate] + 1;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todaysComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    workout.day = todaysComponents.day;
    workout.month = todaysComponents.month;
    workout.year = todaysComponents.year;
    return workout;
}

@end
