//
//  DBWCustomizeWorkoutPlanCollectionHeaderView.m
//  Workout
//
//  Created by Ben Rosen on 8/13/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWCustomizeWorkoutPlanCollectionHeaderView.h"
#import <CompactConstraint/CompactConstraint.h>

@implementation DBWCustomizeWorkoutPlanCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *instructionsLabel = [[UILabel alloc] init];
        instructionsLabel.text = @"Templates contain a list of exercises. You can choose a template when you workout and the exercises will autofill in.\n\n Tap '+' to create a new template.\nPress and hold on a day to reposition it.";
        instructionsLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        instructionsLabel.textColor = [UIColor grayColor];
        instructionsLabel.numberOfLines = 0;
        instructionsLabel.textAlignment = NSTextAlignmentCenter;
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:instructionsLabel];
        
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [UIColor darkGrayColor];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:separator];
        
        [self addCompactConstraints:@[@"separator.top = view.bottom - 0.5",
                                      @"separator.height = 0.5",
                                      @"separator.left = view.left",
                                      @"separator.right = view.right",
                                      @"instructions.top = view.top + 5",
                                      @"instructions.left = view.left + 5",
                                      @"instructions.right = view.right - 5",
                                      @"instructions.bottom = view.bottom - 5"]
                            metrics:nil
                              views:@{@"separator": separator,
                                      @"instructions": instructionsLabel,
                                      @"view": self
                                      }];
        
    }
    return self;
}

@end
