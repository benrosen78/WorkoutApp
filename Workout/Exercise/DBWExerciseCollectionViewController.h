//
//  DBWExerciseCollectionViewController.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWExercise, DBWExerciseCollectionViewCell;

@interface DBWExerciseCollectionViewController : UICollectionViewController

- (instancetype)initWithExercise:(DBWExercise *)exercise exerciseNumber:(NSInteger)number;

@property (strong, nonatomic) DBWExerciseCollectionViewCell *headerCell;

@end