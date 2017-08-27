//
//  DBWCalendarDatePickerViewController.h
//  Workout
//
//  Created by Ben Rosen on 8/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DBWDatePickerDelegate

@required

- (void)monthSelected:(NSInteger)month year:(NSInteger)year;

@end

@interface DBWCalendarDatePickerViewController : UIViewController

@property (nonatomic, weak) id<DBWDatePickerDelegate> delegate;

- (instancetype)initWithCurrentMonth:(NSInteger)month andYear:(NSInteger)year;

@end
