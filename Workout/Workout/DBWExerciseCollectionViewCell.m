//
//  DBWExerciseCollectionViewCell.m
//  Workout
//
//  Created by Ben Rosen on 9/2/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseCollectionViewCell.h"
#import <CompactConstraint/CompactConstraint.h>

@interface DBWExerciseCollectionViewCell ()

@property (strong, nonatomic) UILabel *completedLabel;

@end

@implementation DBWExerciseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_detailLabel];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
        _numberLabel.textColor = [UIColor lightGrayColor];
        _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_numberLabel];
        
        _completedLabel = [[UILabel alloc] init];
        [self setCompleted:_completed];
        _completedLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_completedLabel];
        
        [self.contentView addCompactConstraints:@[@"number.left = view.left + 25",
                                                  @"number.centerY = view.centerY",
                                                  @"title.centerY = view.centerY - 12",
                                                  @"title.left = number.left + 28",
                                                  @"detail.centerY = view.centerY + 12",
                                                  @"detail.left = title.left",
                                                  @"completed.right = view.right - 10",
                                                  @"completed.centerY = view.centerY"]
                                        metrics:nil
                                          views:@{@"number": _numberLabel,
                                                  @"title": _titleLabel,
                                                  @"detail": _detailLabel,
                                                  @"completed": _completedLabel,
                                                  @"view": self.contentView
                                                  }];
    }
    return self;
}

- (void)setCompleted:(BOOL)completed {
    _completed = completed;
    _completedLabel.text = completed ? @"COMPLETED" : @"UNCOMPLETED";
    _completedLabel.font = [UIFont systemFontOfSize:15 weight:completed ? UIFontWeightRegular : UIFontWeightLight];
    _completedLabel.textColor = completed ? [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:1.00] : [UIColor blackColor];
}

@end
