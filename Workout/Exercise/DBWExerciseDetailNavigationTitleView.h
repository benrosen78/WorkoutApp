//
//  DBWExerciseDetailNavigationTitleView.h
//  Workout
//
//  Created by Ben Rosen on 12/10/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DBWExerciseTitleViewAnimationState) {
    DBWExerciseTitleViewAnimationExpandedState,
    DBWExerciseTitleViewAnimationCondensedState
};

@interface DBWExerciseDetailNavigationTitleView : UIView

- (void)animateToState:(DBWExerciseTitleViewAnimationState)animationState;

@property (strong, nonatomic) NSString *titleLabelText, *detailTitleLabelText;

@end
