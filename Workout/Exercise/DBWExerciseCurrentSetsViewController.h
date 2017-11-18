//
//  DBWExerciseCurrentSetsViewController.h
//  Workout
//
//  Created by Ben Rosen on 9/23/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBWExerciseDetailDelegate.h"

@class DBWExercise;

@interface DBWExerciseCurrentSetsViewController : UICollectionViewController

@property (strong, nonatomic) DBWExercise *exercise;

@property (nonatomic) id <DBWExerciseDetailDelegate> delegate;

@end
