//
//  DBWExercisePlaceholderCreationParentDelegate.h
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePlaceholder.h"

@class DBWExercisePlaceholderCreationViewController;

@protocol DBWExercisePlaceholderCreationParentDelegate

@required
- (void)creationViewController:(DBWExercisePlaceholderCreationViewController *)creationViewController changedToHeight:(CGFloat)height;
- (void)creationViewController:(DBWExercisePlaceholderCreationViewController *)creationViewController finishedWithMuscleGroup:(DBWExercisePlaceholderType)group andExerciseName:(NSString *)name;

@end
