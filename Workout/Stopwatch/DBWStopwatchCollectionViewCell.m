//
//  DBWStopwatchCollectionViewCell.m
//  Workout
//
//  Created by Ben Rosen on 10/10/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatchCollectionViewCell.h"
#import "UIColor+ColorPalette.h"
#import "DBWStopwatchCircularCollectionViewLayoutAttributes.h"
#import <CompactConstraint/CompactConstraint.h>

@implementation DBWStopwatchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 50;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightRegular];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_timeLabel];
    
        [self.contentView addCompactConstraints:@[@"timeLabel.centerX = view.centerX",
                                                  @"timeLabel.centerY = view.centerY"]
                                        metrics:nil
                                          views:@{@"timeLabel": _timeLabel,
                                                  @"view": self.contentView
                                                  }];
    }
    return self;
}

- (void)applyLayoutAttributes:(DBWStopwatchCircularCollectionViewLayoutAttributes *)attributes {
    self.layer.anchorPoint = attributes.anchorPoint;
    self.center = CGPointMake(self.center.x, self.center.y + (attributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds));
}

@end
