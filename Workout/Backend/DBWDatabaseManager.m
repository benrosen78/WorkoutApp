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
            
            /* [_workouts beginWriteTransaction];
             [_workouts deleteAllObjects];
             [_workouts commitWriteTransaction];*/
            if ([DBWWorkoutTemplateList allObjectsInRealm:_templates].count < 1) {
                [_templates beginWriteTransaction];
                [_templates addObject:[DBWWorkoutTemplateList new]];
                [_templates commitWriteTransaction];
            }
    
    }
    return self;
}

#pragma mark - Templates DB Management

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

@end
