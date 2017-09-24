//
//  DBWAnimationTransitionController.m
//  Workout
//
//  Created by Ben Rosen on 9/16/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWAnimationTransitionController.h"
#import "DBWWorkoutTodayExercisesViewController.h"
#import "DBWWorkoutPlanDayCell.h"
#import "DBWExerciseCollectionViewController.h"
#import "DBWExerciseCollectionViewCell.h"
#import "DBWAnimationTransitionMemory.h"

@implementation DBWAnimationTransitionController

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    DBWWorkoutTodayExercisesViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DBWExerciseCollectionViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    BOOL push = [toViewController isKindOfClass:[DBWExerciseCollectionViewController class]];
    // make it appear above all other things with a transform and shadow
    [UIView animateWithDuration:0.3 animations:^{
        (push ? _snapshotCellView : fromViewController.headerCell).transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.03, 1.03);
         (push ? _snapshotCellView : fromViewController.headerCell).layer.shadowOpacity = 0.18;
    }];
    

    
    // move it to top position for the next view
    [UIView animateWithDuration:0.55 delay:0.15 usingSpringWithDamping:0.95 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _snapshotCellView.frame = push ? CGRectMake(_snapshotCellView.frame.origin.x, 134, _snapshotCellView.frame.size.width, _snapshotCellView.frame.size.height) : [DBWAnimationTransitionMemory sharedInstance].originalCellFrame;
    } completion:nil];
    

    // animate the collection view away
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromViewController.collectionView.frame = CGRectMake(0, (push ? 1 : -1 ) *fromViewController.collectionView.frame.size.height, fromViewController.collectionView.frame.size.width, fromViewController.collectionView.frame.size.height);
        if (push) {
            fromViewController.headerCell.frame = CGRectMake(0, fromViewController.collectionView.frame.size.height, _snapshotCellView.frame.size.width, _snapshotCellView.frame.size.height);
            fromViewController.headerCell.alpha = 0;


        }
        
        fromViewController.collectionView.alpha = 0;
    } completion:nil];
    

    // make the exercise view with no alpha and put it out of the view so we can animate these proporties
    toViewController.view.backgroundColor = [UIColor clearColor];
    //toViewController.collectionView.backgroundColor = [UIColor clearColor];
    //toViewController.collectionView.alpha = 0;
    //toViewController.headerCell.alpha = 0;
    //toViewController.collectionView.frame = CGRectMake(0, push ? -[[UIScreen mainScreen] bounds].size.height : 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    // get rid of the shadow and transform. make it looked like its placed. then replace it with the same exact header in the new view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        anim.fromValue = @0.18;
        anim.toValue = @0;
        anim.duration = 0.4;
        [_snapshotCellView.layer addAnimation:anim forKey:@"shadowOpacity"];
        _snapshotCellView.layer.shadowOpacity = 0.0;
        [UIView animateWithDuration:0.4 animations:^{
            _snapshotCellView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    });
    
    if (!push) {
        //toViewController.collectionView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        toViewController.headerCell.frame = CGRectMake(25, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width - 50, 110);
    }

    
    // then add the new view. add it as a child view controller so the old view is behind it. then later we actually push it. animate the collection view frame back into view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *container = [transitionContext containerView];
        [container addSubview:toViewController.view];

        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           // toViewController.collectionView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
            if (!push) {
                toViewController.headerCell.frame = CGRectMake(25, 135, [[UIScreen mainScreen] bounds].size.width - 50, 110);
            }
        } completion:nil];
    });
    
    // animate the alpha of the new view to 1 and then actually push the view. change the bg color back to the color we want because the old one would not allow to have animations in both views at the same time.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.4 animations:^{
          //  toViewController.collectionView.alpha = 1;
            if (!push) {
                toViewController.headerCell.alpha = 1;
            }
        } completion:^(BOOL finished) {
            toViewController.headerCell.alpha = 1;
            _snapshotCellView.alpha = 0;
            [_snapshotCellView removeFromSuperview];

            
            toViewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [transitionContext completeTransition:YES];

        }];
    });
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

@end
