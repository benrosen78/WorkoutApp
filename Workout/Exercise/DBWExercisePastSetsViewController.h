//
//  DBWExercisePastSetsViewController.h
//  Workout
//
//  Created by Ben Rosen on 9/25/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWExercisePlaceholder;

@interface DBWExercisePastSetsViewController : UICollectionViewController

- (instancetype)initWithExercisePlaceholder:(DBWExercisePlaceholder *)placeholder;

@end
