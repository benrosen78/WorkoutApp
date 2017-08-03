//
//  DBWExerciseTableViewController.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWExercise;

@protocol DBWExcerciseTableViewControllerDelegate

- (void)finishedWithExcercise:(DBWExercise *)exercise;

@end

@interface DBWExerciseTableViewController : UITableViewController

- (instancetype)initWithExercise:(DBWExercise *)exercise;

@property (nonatomic, weak) id <DBWExcerciseTableViewControllerDelegate> delegate;

@end
