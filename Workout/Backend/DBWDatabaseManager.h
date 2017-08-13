//
//  DBWDatabaseManager.h
//  Workout
//
//  Created by Ben Rosen on 8/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "DBWWorkoutTemplate.h"

@class DBWWorkoutTemplate, RLMResults;

@interface DBWDatabaseManager : NSObject

+ (instancetype)sharedDatabaseManager;

- (RLMArray<DBWWorkoutTemplate> *)allTemplates;

- (void)saveNewWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate;

- (void)moveWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate toIndex:(NSInteger)index;

- (void)startTemplateWriting;

- (void)endTemplateWriting;

- (void)deleteWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate;

@end
