//
//  DBWStopwatchActiveViewController.h
//  Workout
//
//  Created by Ben Rosen on 10/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWStopwatch;

@protocol DBWStopwatchCompletionDelegate

@required
- (void)stopwatchCompleted;

@end

@interface DBWStopwatchActiveViewController : UIViewController

@property (nonatomic) id<DBWStopwatchCompletionDelegate> delegate;

- (instancetype)initWithStopwatch:(DBWStopwatch *)stopwatch;

@end
