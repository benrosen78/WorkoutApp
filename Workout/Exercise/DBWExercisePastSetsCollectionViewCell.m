//
//  DBWExercisePastSetsCollectionViewCell.m
//  Workout
//
//  Created by Ben Rosen on 9/30/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePastSetsCollectionViewCell.h"
#import <CompactConstraint/CompactConstraint.h>

@implementation DBWExercisePastSetsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_dateLabel];
        
        _expectedDataLabel = [[UILabel alloc] init];
        _expectedDataLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _expectedDataLabel.textColor = [UIColor blackColor];
        _expectedDataLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_expectedDataLabel];
        
        [self.contentView addCompactConstraints:@[@"title.centerY = view.centerY - 12",
                                                  @"title.left = view.left + 20",
                                                  @"detail.centerY = view.centerY + 12",
                                                  @"detail.left = title.left"]
                                        metrics:nil
                                          views:@{@"title": _dateLabel,
                                                  @"detail": _expectedDataLabel,
                                                  @"view": self.contentView
                                                  }];
    }
    return self;
}

@end
