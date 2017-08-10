//
//  DBWWorkoutPlanDayCell.m
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutPlanDayCell.h"
#import <CompactConstraint/CompactConstraint.h>

@implementation DBWWorkoutPlanDayCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.contentView.layer.borderWidth = 0.6;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 0;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
        _detailLabel.numberOfLines = 0;
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_detailLabel];
        
        UILabel *chevronLabel = [[UILabel alloc] init];
        chevronLabel.text = @"\u203A";
        chevronLabel.textColor = [UIColor grayColor];
        chevronLabel.font = [UIFont systemFontOfSize:25.0 weight:UIFontWeightRegular];
        chevronLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:chevronLabel];
        
        
        [self.contentView addCompactConstraints:@[@"titleLabel.left = view.left + 10",
                                                  @"titleLabel.right = view.right - 10",
                                                  @"titleLabel.top = view.top + 10",
                                                  @"detailLabel.top = titleLabel.bottom + 10",
                                                  @"detailLabel.left = titleLabel.left",
                                                  @"detailLabel.right = titleLabel.right",
                                                  @"chevronLabel.right = view.right - 5",
                                                  @"chevronLabel.bottom = view.bottom - 5"]
                                        metrics:nil
                                          views:@{@"titleLabel": _titleLabel,
                                                  @"detailLabel": _detailLabel,
                                                  @"chevronLabel": chevronLabel,
                                                  @"view": self.contentView
                                                  }];
    }
    return self;
}

@end
