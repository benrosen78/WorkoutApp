//
//  DBWDatabaseManager.m
//  Workout
//
//  Created by Ben Rosen on 8/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWDatabaseManager.h"
#import <Realm/Realm.h>

@interface DBWDatabaseManager ()

@property (strong, nonatomic) RLMRealm *workouts, *templates;

@end

@implementation DBWDatabaseManager

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
        RLMSyncConfiguration *workoutSyncConfig = [[RLMSyncConfiguration alloc] initWithUser:[RLMSyncUser currentUser] realmURL:[NSURL URLWithString:@"realms://wa.benrosen.me/~/workout"]];
        RLMRealmConfiguration *workoutRealmConfig = [RLMRealmConfiguration defaultConfiguration];
        workoutRealmConfig.syncConfiguration = workoutSyncConfig;
        
        RLMSyncConfiguration *templateSyncConfig = [[RLMSyncConfiguration alloc] initWithUser:[RLMSyncUser currentUser] realmURL:[NSURL URLWithString:@"realms://wa.benrosen.me/~/template"]];
        RLMRealmConfiguration *templateRealmConfig = [RLMRealmConfiguration defaultConfiguration];
        templateRealmConfig.syncConfiguration = templateSyncConfig;
        
        _workouts = [RLMRealm realmWithConfiguration:workoutRealmConfig error:nil];
        _templates = [RLMRealm realmWithConfiguration:templateRealmConfig error:nil];
    }
    return self;
}

@end
