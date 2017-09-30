//
//  DBWDatabaseManager.m
//  Workout
//
//  Created by Ben Rosen on 8/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWDatabaseManager.h"
#import <Realm/Realm.h>
#import "DBWWorkoutTemplate.h"
#import "DBWWorkoutTemplateList.h"
#import "DBWWorkout.h"
#import "DBWExercise.h"
#import "DBWExercisePlaceholder.h"
#import "DBWExerciseDatabase.h"
#import "DBWSet.h"

@interface DBWDatabaseManager ()

@property (strong, nonatomic) RLMRealm *templates;

@end

@implementation DBWDatabaseManager

#pragma mark - Initialization

+ (instancetype)sharedDatabaseManager {
    static DBWDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBWDatabaseManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        RLMSyncConfiguration *templateSyncConfig = [[RLMSyncConfiguration alloc] initWithUser:[RLMSyncUser currentUser] realmURL:[NSURL URLWithString:@"realms://wa.benrosen.me/~/templates"]];
        RLMRealmConfiguration *templateRealmConfig = [RLMRealmConfiguration defaultConfiguration];
        templateRealmConfig.syncConfiguration = templateSyncConfig;
        _templates = [RLMRealm realmWithConfiguration:templateRealmConfig error:nil];
        
        if ([DBWWorkoutTemplateList allObjectsInRealm:_templates].count < 1) {
            [_templates beginWriteTransaction];
            [_templates addObject:[DBWWorkoutTemplateList new]];
            [_templates commitWriteTransaction];
        }
        
        if ([DBWExerciseDatabase allObjectsInRealm:_templates].count < 1) {
            [_templates beginWriteTransaction];
            [_templates addObject:[DBWExerciseDatabase new]];
            [_templates commitWriteTransaction];
        }

        /* for loading in arbitrary data:
 
        int day = 10;
        
         for (DBWWorkoutTemplate *template in [self templateList].list) {
            DBWWorkout *wo = [[DBWWorkout alloc] init];
            wo.selectedColorIndex = template.selectedColorIndex;
            wo.templateDay = [self.templateList.list indexOfObject:template] + 1;
            wo.day = day;
            wo.month = 9;
            wo.year = 2017;
            [self saveNewWorkout:wo];
             
             [[DBWDatabaseManager sharedDatabaseManager] addExercises:template.exercises toWorkout:wo];
             for (DBWExercise *exercise in wo.exercises) {
                 DBWSet *set1 = [[DBWSet alloc] init];
                 set1.weight = day * 5;
                 set1.reps = 10;
                 [exercise.sets addObject:set1];
                 
                 DBWSet *set2 = [[DBWSet alloc] init];
                 set2.weight = day * 5;
                 set2.reps = 10;
                 [exercise.sets addObject:set1];
                 DBWSet *set3 = [[DBWSet alloc] init];
                 set3.weight = day * 5;
                 set3.reps = 10;
                 [exercise.sets addObject:set3];
                 
             }

             
            day+= 3;
        }
        */
    }
    return self;
}

#pragma mark - Templates DB Management

- (void)addExercises:(RLMArray<DBWExercise> *)exercises toWorkout:(DBWWorkout *)workout {
    [_templates beginWriteTransaction];
    for (DBWExercise *exercise in exercises) {
        [workout.exercises addObject:[DBWExercise createInRealm:_templates withValue:exercise]];
    }
    [_templates commitWriteTransaction];
}

- (void)saveNewWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    [_templates beginWriteTransaction];
    
    DBWWorkoutTemplateList *list = [DBWWorkoutTemplateList allObjectsInRealm:_templates][0];
    [list.list addObject:workoutTemplate];
    [_templates commitWriteTransaction];
}

- (DBWWorkoutTemplateList *)templateList {
    return [DBWWorkoutTemplateList allObjectsInRealm:_templates][0];
}

- (void)deleteWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    [_templates beginWriteTransaction];
    [_templates deleteObject:workoutTemplate];
    [_templates commitWriteTransaction];
}

- (void)moveWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate toIndex:(NSInteger)newIndex {  
    DBWWorkoutTemplateList *list = [DBWWorkoutTemplateList allObjectsInRealm:_templates][0];
    RLMArray <DBWWorkoutTemplate> *templates = list.list;
    
    NSInteger index = [templates indexOfObject:workoutTemplate];
    if (index != NSNotFound) {
        [_templates beginWriteTransaction];
        [templates moveObjectAtIndex:index toIndex:newIndex];
        [_templates commitWriteTransaction];
    }
}

- (void)startTemplateWriting {
    [_templates beginWriteTransaction];
}

- (void)endTemplateWriting {
    [_templates commitWriteTransaction];
}

#pragma mark - Workouts DB Management

- (void)saveNewWorkout:(DBWWorkout *)workout {
    [_templates beginWriteTransaction];
    [_templates addObject:workout];
    [_templates commitWriteTransaction];
}

- (DBWWorkout *)workoutForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    return [DBWWorkout objectsInRealm:_templates withPredicate:[NSPredicate predicateWithFormat:@"day = %d AND month = %d AND year = %d", day, month, year]].firstObject;
}

- (DBWWorkout *)todaysWorkout {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todaysComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    return [self workoutForDay:todaysComponents.day month:todaysComponents.month year:todaysComponents.year];
}

- (NSArray <NSNumber *> *)yearsInDatabase {
    NSMutableArray <NSNumber *> *years = [NSMutableArray array];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [years addObject:@(components.year)];
    
    NSInteger year = components.year;
    while ([[DBWWorkout objectsInRealm:_templates withPredicate:[NSPredicate predicateWithFormat:@"year = %d", --year]] count] > 0) {
        [years addObject:@(year)];
    }
    return [[[NSArray arrayWithArray:years] reverseObjectEnumerator] allObjects];
}

#pragma mark - Exercise Placeholders

- (void)saveNewExercisePlaceholder:(DBWExercisePlaceholder *)placeholer {
    [_templates beginWriteTransaction];
    
    DBWExerciseDatabase *list = [DBWExerciseDatabase allObjectsInRealm:_templates][0];
    [list.list addObject:placeholer];
    [_templates commitWriteTransaction];
    
}

- (DBWExerciseDatabase *)allExercisePlaceholders {
    return [DBWExerciseDatabase allObjectsInRealm:_templates][0];
}

- (RLMResults *)exercisesForPlaceholder:(DBWExercisePlaceholder *)placeholder {
    // this will obtain all past exercises from all past workouts for a given placeholder.
    // it does this by getting all the exercises with that placeholder, and then it makes sure that it is not
    // a template exercise by checking if it is attached to a workout.
    // lastly, since it is a past exercise, it can't be on the curent day
    NSDateComponents *todaysComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    

    
    return [DBWExercise objectsInRealm:_templates withPredicate:[NSPredicate predicateWithFormat:@"placeholder.primaryKey == %@ AND workouts.@count > 0 AND SUBQUERY(workouts, $workouts, $workouts.day == %d AND $workouts.month == %d AND $workouts.year == %d).@count == 0", placeholder.primaryKey, todaysComponents.day, todaysComponents.month, todaysComponents.year]];
}

@end
