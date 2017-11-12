//
//  DBWExercisePlaceholderCreationDelegate.h
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePlaceholder.h"

@protocol DBWExercisePlaceholderCreationDelegate

@required
- (void)selectedMuscleGroup:(DBWExercisePlaceholderType)muscleGroup;
@end
