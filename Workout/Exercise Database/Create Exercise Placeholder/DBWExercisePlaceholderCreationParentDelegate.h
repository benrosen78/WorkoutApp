//
//  DBWExercisePlaceholderCreationParentDelegate.h
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

@class DBWExercisePlaceholder, DBWExercisePlaceholderCreationViewController;

@protocol DBWExercisePlaceholderCreationParentDelegate

@required
- (void)creationViewController:(DBWExercisePlaceholderCreationViewController *)creationViewController changedToHeight:(CGFloat)height;
- (void)creationViewController:(DBWExercisePlaceholderCreationViewController *)creationViewController finishedWithPlaceholder:(DBWExercisePlaceholder *)placeholder;

@end
