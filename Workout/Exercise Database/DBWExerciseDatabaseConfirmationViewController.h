//
//  DBWExerciseDatabaseConfirmationViewController.h
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBWExerciseDatabaseDelegate.h"

@class DBWExercisePlaceholder;

@interface DBWExerciseDatabaseConfirmationViewController : UIViewController

@property (strong, nonatomic) DBWExercisePlaceholder *selectedPlaceholder;

@property (weak, nonatomic) id<DBWExerciseDatabaseDelegate> delegate;

@end
