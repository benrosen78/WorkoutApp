//
//  DBWTemplateCustomizationTableViewController.h
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWWorkoutTemplate;

@interface DBWTemplateCustomizationTableViewController : UITableViewController

- (instancetype)initWithTemplate:(DBWWorkoutTemplate *)workoutTemplate;

@end
