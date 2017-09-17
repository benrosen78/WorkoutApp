//
//  DBWAnimationTransitionController.h
//  Workout
//
//  Created by Ben Rosen on 9/16/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBWAnimationTransitionController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIView *snapshotCellView;

@end
