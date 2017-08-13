//
//  DBWDatabaseManager.h
//  Workout
//
//  Created by Ben Rosen on 8/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBWWorkoutTemplate, RLMResults;

@interface DBWDatabaseManager : NSObject

+ (instancetype)sharedDatabaseManager;

- (RLMResults *)allTemplates;

- (void)saveWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate;

- (void)startTemplateWriting;

- (void)endTemplateWriting;

- (void)deleteWorkoutTemplate:(DBWWorkoutTemplate *)workoutTemplate;

@end
