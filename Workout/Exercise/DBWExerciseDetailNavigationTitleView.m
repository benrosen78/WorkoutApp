//
//  DBWExerciseDetailNavigationTitleView.m
//  Workout
//
//  Created by Ben Rosen on 12/10/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseDetailNavigationTitleView.h"

@interface DBWExerciseDetailNavigationTitleView()

@property (strong, nonatomic) UILabel *titleLabel, *detailTitleLabel;

@property (strong, nonatomic) NSLayoutConstraint *titleLabelHeightConstraint, *detailTitleLabelHeightConstraint;

@property (nonatomic) DBWExerciseTitleViewAnimationState currentState;

@end

@implementation DBWExerciseDetailNavigationTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentState = DBWExerciseTitleViewAnimationCondensedState;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _titleLabelText ?: @"Set Text";
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
        
        _detailTitleLabel = [[UILabel alloc] init];
        _detailTitleLabel.text = _detailTitleLabelText ?: @"Set Text";

        _detailTitleLabel.textAlignment = NSTextAlignmentCenter;
        _detailTitleLabel.alpha = 0;
        _detailTitleLabel.adjustsFontSizeToFitWidth = YES;
        _detailTitleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        _detailTitleLabel.textColor = [UIColor blackColor];
        _detailTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_detailTitleLabel];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [_titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [_titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [_titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;

    [_detailTitleLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:-6].active = YES;
    [_detailTitleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [_detailTitleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [_detailTitleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    if (_currentState == DBWExerciseTitleViewAnimationExpandedState) {
        [_titleLabel.heightAnchor constraintEqualToConstant:25].active = YES;
    } else {
        [_titleLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    }
}

- (void)animateToState:(DBWExerciseTitleViewAnimationState)animationState {
    if (animationState == DBWExerciseTitleViewAnimationExpandedState && _currentState != DBWExerciseTitleViewAnimationExpandedState) {
        _currentState = DBWExerciseTitleViewAnimationExpandedState;
        
        [_titleLabel removeFromSuperview];
        [self addSubview:_titleLabel];
        
        [_detailTitleLabel removeFromSuperview];
        [self addSubview:_detailTitleLabel];
        
        [self updateConstraints];
        
        [UIView animateWithDuration:0.3 animations:^{
            _detailTitleLabel.alpha = 1;
            _titleLabel.transform = CGAffineTransformMakeScale((15.0/17.0), (15.0/17.0));
            [self layoutIfNeeded];
        }];
    } else if (animationState == DBWExerciseTitleViewAnimationCondensedState && _currentState != DBWExerciseTitleViewAnimationCondensedState) {
        _currentState = DBWExerciseTitleViewAnimationCondensedState;
        [_titleLabel removeFromSuperview];
        [self addSubview:_titleLabel];
        
        [_detailTitleLabel removeFromSuperview];
        [self addSubview:_detailTitleLabel];
        
        [self updateConstraints];
        [UIView animateWithDuration:0.3 animations:^{
            _detailTitleLabel.alpha = 0;
            
            _titleLabel.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        }];
    }
}

- (void)setTitleLabelText:(NSString *)titleLabelText {
    _titleLabelText = titleLabelText;
    _titleLabel.text = _titleLabelText;
}

- (void)setDetailTitleLabelText:(NSString *)detailTitleLabelText {
    _detailTitleLabelText = detailTitleLabelText;
    _detailTitleLabel.text = _detailTitleLabelText;
}

@end
