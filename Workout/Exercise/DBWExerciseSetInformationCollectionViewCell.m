//
//  DBWExerciseSetInformationCollectionViewCell.m
//  Workout
//
//  Created by Ben Rosen on 9/30/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseSetInformationCollectionViewCell.h"
#import <CompactConstraint/CompactConstraint.h>

@implementation DBWExerciseSetInformationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_textLabel];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        _numberLabel.textColor = [UIColor lightGrayColor];
        _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_numberLabel];
        
        [self.contentView addCompactConstraints:@[@"number.left = view.left + 18",
                                                  @"number.centerY = view.centerY",
                                                  @"text.centerY = view.centerY",
                                                  @"text.left = number.right + 18",
                                                  ]
                                        metrics:nil
                                          views:@{@"text": _textLabel,
                                                  @"number": _numberLabel,
                                                  @"view": self.contentView
                                                  }];
    }
    return self;
}

@end
