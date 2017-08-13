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
        [templateRealmConfig setDeleteRealmIfMigrationNeeded:YES];
    }
    return self;
}

#pragma mark - Templates DB Management

- (void)saveWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    [_templates beginWriteTransaction];
    [_templates addOrUpdateObject:workoutTemplate];
    [_templates commitWriteTransaction];
}

- (RLMResults *)allTemplates {
    return [DBWWorkoutTemplate allObjectsInRealm:_templates];
}

- (void)deleteWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    [_templates beginWriteTransaction];
    [_templates deleteObject:workoutTemplate];
    [_templates commitWriteTransaction];
}

- (void)moveWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate toIndex:(NSInteger)index {
    RLMResults *results = [self allTemplates];
    [results ]
    if ([_ containsObject:workoutTemplate]) {
        [dataContents removeObject:workoutTemplate];
        [dataContents insertObject:workoutTemplate atIndex:index];
}

- (void)startTemplateWriting {
    [_templates beginWriteTransaction];
}

- (void)endTemplateWriting {
    [_templates commitWriteTransaction];
}

@end
