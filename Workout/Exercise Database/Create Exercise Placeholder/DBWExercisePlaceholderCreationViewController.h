//
//  DBWExercisePlaceholderCreationViewController.h
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBWExercisePlaceholderCreationParentDelegate.h"

@interface DBWExercisePlaceholderCreationViewController : UIViewController

@property (nonatomic, weak) id<DBWExercisePlaceholderCreationParentDelegate> delegate;

@end
