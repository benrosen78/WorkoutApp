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
        _completedLabel.text = @"UNCOMPLETED";
        _completedLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
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

@end
