//
//  DBWExercisePlaceholderCreationMuscleSelectionViewController.h
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBWExercisePlaceholderCreationDelegate.h"

@interface DBWExercisePlaceholderCreationMuscleSelectionViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<DBWExercisePlaceholderCreationDelegate> completionDelegate;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
