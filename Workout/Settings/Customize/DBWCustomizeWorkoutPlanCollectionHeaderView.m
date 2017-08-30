//
//  DBWCustomizeWorkoutPlanCollectionHeaderView.m
//  Workout
//
//  Created by Ben Rosen on 8/13/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWCustomizeWorkoutPlanCollectionHeaderView.h"
#import <CompactConstraint/CompactConstraint.h>

@interface DBWCustomizeWorkoutPlanCollectionHeaderView ()

@property (strong, nonatomic) UILabel *instructionsLabel;

@end

@implementation DBWCustomizeWorkoutPlanCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _instructionsLabel = [[UILabel alloc] init];
        _instructionsLabel.text = self.instructionsText;
        _instructionsLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        _instructionsLabel.textColor = [UIColor blackColor];
        _instructionsLabel.numberOfLines = 0;
        _instructionsLabel.textAlignment = NSTextAlignmentCenter;
        _instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_instructionsLabel];
        
        UIView *separator = [[UIView alloc] init];
        //separator.backgroundColor = [UIColor darkGrayColor];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:separator];
        
        [self addCompactConstraints:@[@"separator.top = view.bottom - 0.5",
                                      @"separator.height = 0.5",
                                      @"separator.left = view.left",
                                      @"separator.right = view.right",
                                      @"instructions.top = view.top + 5",
                                      @"instructions.left = view.left + spacing",
                                      @"instructions.right = view.right - spacing",
                                      @"instructions.bottom = view.bottom - 5"]
                            metrics:@{@"spacing": UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @50 : @10}
                              views:@{@"separator": separator,
                                      @"instructions": _instructionsLabel,
                                      @"view": self
                                      }];
        
    }
    return self;
}

- (void)setInstructionsText:(NSString *)instructionsText {
    _instructionsText = instructionsText;
    _instructionsLabel.text = instructionsText;
}

@end
