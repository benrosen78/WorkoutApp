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
#import "DBWCalendar.h"

@interface DBWDatabaseManager ()

@property (strong, nonatomic) RLMRealm *userRealm;

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
        RLMSyncConfiguration *userRealmSyncConfig = [[RLMSyncConfiguration alloc] initWithUser:[RLMSyncUser currentUser] realmURL:[NSURL URLWithString:@"realms://wa.benrosen.me/~/userRealm"]];
        RLMRealmConfiguration *userRealmConfig = [RLMRealmConfiguration defaultConfiguration];
        userRealmConfig.syncConfiguration = userRealmSyncConfig;
        
        _userRealm = [RLMRealm realmWithConfiguration:userRealmConfig error:nil];
        
        if ([DBWWorkoutTemplateList allObjectsInRealm:_userRealm].count < 1) {
            [_userRealm beginWriteTransaction];
            [_userRealm addObject:[DBWWorkoutTemplateList new]];
            [_userRealm commitWriteTransaction];
        }
        
        if ([DBWExerciseDatabase allObjectsInRealm:_userRealm].count < 1) {
            [_userRealm beginWriteTransaction];
            [_userRealm addObject:[DBWExerciseDatabase new]];
            [_userRealm commitWriteTransaction];
        }

        if ([DBWCalendar allObjectsInRealm:_userRealm].count < 1) {
            [_userRealm beginWriteTransaction];
            [_userRealm addObject:[DBWCalendar new]];
            [_userRealm commitWriteTransaction];
        }
        
        /* for loading in arbitrary data:
        
        for (int day = 1; day <= 6; day++) {
            DBWWorkoutTemplate *template = [self templateList].list[0];
            DBWWorkout *wo = [[DBWWorkout alloc] init];
            wo.selectedColorIndex = template.selectedColorIndex;
            wo.templateDay = [self.templateList.list indexOfObject:template] + 1;
            
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.day = day;
            dateComponents.month = 10;
            dateComponents.year = 2017;
            
            wo.date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
            
            
             [self addExercises:template.exercises toWorkout:wo];
         
         [self saveNewWorkout:wo];

             [_userRealm beginWriteTransaction];
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
             [_userRealm commitWriteTransaction];

        }*/
        
    }
    return self;
}

#pragma mark - Templates DB Management

- (void)addExercises:(RLMArray<DBWExercise> *)exercises toWorkout:(DBWWorkout *)workout {
    [_userRealm beginWriteTransaction];
    for (DBWExercise *exercise in exercises) {
        [workout.exercises addObject:[DBWExercise createInRealm:_userRealm withValue:exercise]];
    }
    [_userRealm commitWriteTransaction];
}

- (void)saveNewWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    [_userRealm beginWriteTransaction];
    
    DBWWorkoutTemplateList *list = [DBWWorkoutTemplateList allObjectsInRealm:_userRealm][0];
    [list.list addObject:workoutTemplate];
    [_userRealm commitWriteTransaction];
}

- (DBWWorkoutTemplateList *)templateList {
    return [DBWWorkoutTemplateList allObjectsInRealm:_userRealm][0];
}

- (void)deleteWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    [_userRealm beginWriteTransaction];
    [_userRealm deleteObject:workoutTemplate];
    [_userRealm commitWriteTransaction];
}

- (void)moveWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate toIndex:(NSInteger)newIndex {  
    DBWWorkoutTemplateList *list = [DBWWorkoutTemplateList allObjectsInRealm:_userRealm][0];
    RLMArray <DBWWorkoutTemplate> *templates = list.list;
    
    NSInteger index = [templates indexOfObject:workoutTemplate];
    if (index != NSNotFound) {
        [_userRealm beginWriteTransaction];
        [templates moveObjectAtIndex:index toIndex:newIndex];
        [_userRealm commitWriteTransaction];
    }
}

- (void)startTemplateWriting {
    [_userRealm beginWriteTransaction];
}

- (void)endTemplateWriting {
    [_userRealm commitWriteTransaction];
}

#pragma mark - Workouts DB Management

- (void)saveNewWorkout:(DBWWorkout *)workout {
    [_userRealm beginWriteTransaction];
    
    DBWCalendar *calendar = [DBWCalendar allObjectsInRealm:_userRealm][0];
    [calendar.workouts addObject:workout];
    [_userRealm commitWriteTransaction];
}

- (DBWWorkout *)workoutForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    dateComponents.month = month;
    dateComponents.year = year;
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:kNilOptions];
    
    return [DBWWorkout objectsInRealm:_userRealm withPredicate:[NSPredicate predicateWithFormat:@"date >= %@ && date < %@", startDate, endDate]].firstObject;
}

- (DBWWorkout *)todaysWorkout {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todaysComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    return [self workoutForDay:todaysComponents.day month:todaysComponents.month year:todaysComponents.year];
}

- (NSArray <NSNumber *> *)yearsInDatabase {
    NSMutableArray <NSNumber *> *years = [NSMutableArray array];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    components.month = 0;
    components.day = 0;
    NSInteger year = components.year;
    
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitYear value:1 toDate:startDate options:kNilOptions];

    while ([[DBWWorkout objectsInRealm:_userRealm withPredicate:[NSPredicate predicateWithFormat:@"date >= %@ && date < %@", startDate, endDate]] count] > 0) {
        [years addObject:@(year)];
        year--;
        
        components.year = year;
        startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        endDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitYear value:1 toDate:startDate options:kNilOptions];

        
    }
    return [[[NSArray arrayWithArray:years] reverseObjectEnumerator] allObjects];
}

#pragma mark - Exercise Placeholders

- (void)saveNewExercisePlaceholder:(DBWExercisePlaceholder *)placeholer {
    [_userRealm beginWriteTransaction];
    
    DBWExerciseDatabase *list = [DBWExerciseDatabase allObjectsInRealm:_userRealm][0];
    [list.list addObject:placeholer];
    [_userRealm commitWriteTransaction];
}

- (DBWExerciseDatabase *)allExercisePlaceholders {
    return [DBWExerciseDatabase allObjectsInRealm:_userRealm][0];
}

- (NSArray *)pastExercisesForPlaceholder:(DBWExercisePlaceholder *)placeholder  {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    RLMResults *unsortedWorkoutResults = [DBWWorkout objectsInRealm:_userRealm withPredicate:[NSPredicate predicateWithFormat:@"SUBQUERY(exercises, $exercises, $exercises.placeholder.primaryKey == %@).@count > 0 AND date < %@", placeholder.primaryKey, startDate]];
    RLMResults *workoutResults = [unsortedWorkoutResults sortedResultsUsingKeyPath:@"date" ascending:NO];
    NSMutableArray *exercises = [NSMutableArray array];
    for (DBWWorkout *workout in workoutResults) {
        for (DBWExercise *exercise in [workout.exercises objectsWithPredicate:[NSPredicate predicateWithFormat:@"placeholder.primaryKey == %@", placeholder.primaryKey]]) {
            [exercises addObject:exercise];
        }
    }
    return [NSArray arrayWithArray:exercises];
}

@end
