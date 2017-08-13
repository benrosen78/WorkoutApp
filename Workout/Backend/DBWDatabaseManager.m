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

@interface DBWDatabaseManager ()

@property (strong, nonatomic) RLMRealm *workouts, *templates;

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
        RLMSyncConfiguration *workoutSyncConfig = [[RLMSyncConfiguration alloc] initWithUser:[RLMSyncUser currentUser] realmURL:[NSURL URLWithString:@"realms://wa.benrosen.me/~/workouts"]];
        RLMRealmConfiguration *workoutRealmConfig = [RLMRealmConfiguration defaultConfiguration];
        workoutRealmConfig.syncConfiguration = workoutSyncConfig;
        
        
        RLMSyncConfiguration *templateSyncConfig = [[RLMSyncConfiguration alloc] initWithUser:[RLMSyncUser currentUser] realmURL:[NSURL URLWithString:@"realms://wa.benrosen.me/~/templates"]];
        RLMRealmConfiguration *templateRealmConfig = [RLMRealmConfiguration defaultConfiguration];
        templateRealmConfig.syncConfiguration = templateSyncConfig;
        
        _workouts = [RLMRealm realmWithConfiguration:workoutRealmConfig error:nil];
        _templates = [RLMRealm realmWithConfiguration:templateRealmConfig error:nil];
        
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

- (RLMArray *)allTemplates {
    DBWWorkoutTemplateList *list = [DBWWorkoutTemplateList allObjectsInRealm:_templates][0];
    return list.list;
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
        [templates removeObjectAtIndex:index];
        [templates insertObject:workoutTemplate atIndex:newIndex];
        [_templates commitWriteTransaction];
    }
}

- (void)startTemplateWriting {
    [_templates beginWriteTransaction];
}

- (void)endTemplateWriting {
    [_templates commitWriteTransaction];
}

@end
