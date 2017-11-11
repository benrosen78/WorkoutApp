//
//  DBWWorkoutTodayViewController.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutTodayViewController.h"
#import "DBWWorkout.h"
#import "DBWExercise.h"
#import "DBWExerciseCollectionViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWWorkoutTemplate.h"
#import "DBWDatabaseManager.h"
#import "DBWCustomizeWorkoutPlanCollectionHeaderView.h"
#import "DBWWorkoutPlanDayCell.h"
#import "DBWWorkoutTodayExercisesViewController.h"
#import "DBWWorkoutTemplateList.h"
#import "UIColor+ColorPalette.h"
#import "AppDelegate.h"

@interface DBWWorkoutTodayViewController ()


@end

@implementation DBWWorkoutTodayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.prefersLargeTitles = NO;

    _workout = [[DBWDatabaseManager sharedDatabaseManager] todaysWorkout];
    if (!_workout) {
        return;
    }

    DBWWorkoutTodayExercisesViewController *exercisesViewController = [[DBWWorkoutTodayExercisesViewController alloc] initWithWorkout:_workout];
    exercisesViewController.headerCellAlpha = 1;
    exercisesViewController.tabBarItem = self.tabBarItem;
    self.navigationController.viewControllers = @[exercisesViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Today's Gains";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    // create a snapshot and set up a shadow
    UIView *headerView = [cell snapshotViewAfterScreenUpdates:NO];
    headerView.layer.shadowRadius = 10;
    headerView.layer.shadowOffset = CGSizeMake(0, 0);
    headerView.layer.shadowOpacity = 0.0;
    headerView.frame = [self.view convertRect:cell.frame fromView:self.collectionView];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:headerView];

    // make it appear above all other things with a transform and shadow
    [UIView animateWithDuration:0.3 animations:^{
        headerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.03, 1.03);
        headerView.layer.shadowOpacity = 0.18;
    }];
    
    
    // move it to top position for the next view
    [headerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:14].active = YES;
    [headerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:12.5].active = YES;
    [headerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-12.5].active = YES;
    [headerView.heightAnchor constraintEqualToConstant:105].active = YES;

    [UIView animateWithDuration:0.55 delay:0.15 usingSpringWithDamping:0.95 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
    // animate the collection view away
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.collectionView.frame = CGRectMake(0, self.collectionView.frame.size.height, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
        self.collectionView.alpha = 0;
    } completion:nil];
    
    // make the exercise view with no alpha and put it out of the view so we can animate these proporties
    DBWWorkout *workout = [DBWWorkout todaysWorkoutWithTemplate:self.templateList.list[indexPath.row]];
    [[DBWDatabaseManager sharedDatabaseManager] saveNewWorkout:workout];

    DBWWorkoutTodayExercisesViewController *exercisesViewController = [[DBWWorkoutTodayExercisesViewController alloc] initWithWorkout:workout];

    exercisesViewController.headerCellAlpha = 0;
    exercisesViewController.view.backgroundColor = [UIColor clearColor];
    exercisesViewController.collectionView.backgroundColor = [UIColor clearColor];
    exercisesViewController.collectionView.alpha = 0;
    exercisesViewController.collectionView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

    // get rid of the shadow and transform. make it looked like its placed. then replace it with the same exact header in the new view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            headerView.layer.shadowOpacity = 0;
            headerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    });
    
    // then add the new view. add it as a child view controller so the old view is behind it. then later we actually push it. animate the collection view frame back into view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addChildViewController:exercisesViewController];
        [self.view addSubview:exercisesViewController.view];
        [exercisesViewController didMoveToParentViewController:self];

        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            exercisesViewController.collectionView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        } completion:nil];
    });
    
    // animate the alpha of the new view to 1 and then actually push the view. change the bg color back to the color we want because the old one would not allow to have animations in both views at the same time.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            exercisesViewController.collectionView.alpha = 1;
        } completion:^(BOOL finished) {
            [headerView removeFromSuperview];
            exercisesViewController.headerCell.alpha = 1;

            exercisesViewController.tabBarItem = self.tabBarItem;
            
            exercisesViewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [exercisesViewController willMoveToParentViewController:nil];
            self.navigationController.viewControllers = @[exercisesViewController];
        }];
    });
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    DBWCustomizeWorkoutPlanCollectionHeaderView *headerView = (DBWCustomizeWorkoutPlanCollectionHeaderView *)[super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    if ([collectionView numberOfItemsInSection:0] > 0) {
        headerView.instructionsText = @"Select the workout that today's workout will be structured upon. To customize your workouts, go to Settings and customize your workout plan.";
    } else {
        headerView.instructionsText = @"You haven't created a workout plan yet.\n\nGo to Settings to customize your workout plan and then come back here.";
    }
    return headerView;
    
}



@end
