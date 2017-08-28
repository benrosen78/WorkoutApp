
//
//  DBWCalendarCollectionViewCell.m
//  Workout
//
//  Created by Ben Rosen on 8/26/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWCalendarCollectionViewCell.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWCalendarCellLabel.h"

@implementation DBWCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _workoutLabel = [[DBWCalendarCellLabel alloc] init];
        _workoutLabel.textColor = [UIColor whiteColor];
        _workoutLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _workoutLabel.layer.masksToBounds = YES;
        _workoutLabel.layer.cornerRadius = 2;
        _workoutLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_workoutLabel];
        
        _colorView = [[UIView alloc] init];
        _colorView.layer.masksToBounds = YES;
        _colorView.layer.cornerRadius = 17;
        _colorView.backgroundColor = [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00];
        _colorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_colorView];
        
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightRegular];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_dayLabel];
        
        [self.contentView addCompactConstraints:@[@"day.top = view.top + 10",
                                                  @"day.right = view.right - 14",
                                                  @"workout.centerX = view.centerX",
                                                  @"workout.centerY = view.centerY",
                                                  @"workout.left = view.left + 13",
                                                  @"workout.right = view.right - 13",
                                                  @"workout.height = 25",
                                                  @"color.centerX = day.centerX",
                                                  @"color.centerY = day.centerY",
                                                  @"color.height = 34",
                                                  @"color.width = 34"]
                                        metrics:nil
                                          views:@{@"day": _dayLabel,
                                                  @"workout": _workoutLabel,
                                                  @"view": self.contentView,
                                                  @"color": _colorView
                                                  }];
    }
    return self;
}

@end
