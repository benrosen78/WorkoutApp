//
//  DBWExercisePlaceholder.h
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Realm/Realm.h>

typedef NS_ENUM(NSInteger, DBWExercisePlaceholderType) {
    DBWExercisePlaceholderChestType,
    DBWExercisePlaceholderBackType,
    DBWExercisePlaceholderShouldersType,
    DBWExercisePlaceholderCoreType,
    DBWExercisePlaceholderArmsType,
    DBWExercisePlaceholderLegsType,
};

@interface DBWExercisePlaceholder : RLMObject

@property NSString *name, *primaryKey;

@property DBWExercisePlaceholderType type;

+ (NSString *)stringForExercisePlaceholderType:(DBWExercisePlaceholderType)type;

@end
