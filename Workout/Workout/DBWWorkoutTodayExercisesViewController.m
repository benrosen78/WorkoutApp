//
//  DBWWorkoutTodayExercisesViewController.m
//  Workout
//
//  Created by Ben Rosen on 9/2/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutTodayExercisesViewController.h"
#import "DBWWorkout.h"
#import "DBWExercise.h"
#import "DBWExerciseSetCollectionViewCell.h"
#import "DBWExerciseCollectionViewController.h"
#import "DBWWorkoutPlanDayCell.h"
#import "UIColor+ColorPalette.h"
#import "DBWExerciseCollectionViewCell.h"

@interface DBWWorkoutTodayExercisesViewController () <UINavigationControllerDelegate>

@property (strong, nonatomic) DBWWorkout *workout;

@end

@implementation DBWWorkoutTodayExercisesViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithWorkout:(DBWWorkout *)workout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 50, 68);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(150, 0, 0, 0);
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        _workout = workout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerCell = [[DBWWorkoutPlanDayCell alloc] initWithFrame:CGRectMake(25, 135, self.view.frame.size.width - 50, 110)];
    _headerCell.layer.cornerRadius = 8;
    _headerCell.layer.masksToBounds = YES;
    _headerCell.backgroundColor = [UIColor whiteColor];
    _headerCell.titleLabel.text = [NSString stringWithFormat:@"Day %lu", _workout.templateDay];
    _headerCell.detailLabel.text = _workout.comments;
    _headerCell.color = [UIColor calendarColors][_workout.selectedColorIndex];
    [self.view addSubview:_headerCell];
    
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.hidesBackButton = YES;
    [self.collectionView registerClass:[DBWExerciseCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_workout.exercises count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBWExercise *exercise = _workout.exercises[indexPath.row];
    
    DBWExerciseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (indexPath.row == 0 || indexPath.row == [_workout.exercises count] - 1) {
        UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:indexPath.row == 0 ? (UIRectCornerTopLeft | UIRectCornerTopRight) : (UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        cell.layer.mask = shape;
    } else {
        cell.layer.mask = nil;
    }
    
    cell.numberLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row + 1];
    cell.titleLabel.text = exercise.name;
    cell.detailLabel.text = @"5 x 5";
    cell.completed = [exercise setsCompleted];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    
        cell.layer.mask = nil;
        cell.layer.cornerRadius = 8;
        cell.layer.masksToBounds = YES;

    
    // create a snapshot and set up a shadow
    UIView *headerView = [cell snapshotViewAfterScreenUpdates:YES];
    headerView.layer.shadowRadius = 10;
    headerView.layer.shadowOffset = CGSizeMake(0, 0);
    headerView.layer.shadowOpacity = 0.0;
    headerView.frame = [self.view convertRect:cell.frame fromView:self.collectionView];
    [self.view addSubview:headerView];
    
    // make it appear above all other things with a transform and shadow
    [UIView animateWithDuration:0.3 animations:^{
        headerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.03, 1.03);
        headerView.layer.shadowOpacity = 0.18;
    }];
    
    // move it to top position for the next view
    [UIView animateWithDuration:0.55 delay:0.15 usingSpringWithDamping:0.95 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        headerView.frame = CGRectMake(headerView.frame.origin.x, 135, headerView.frame.size.width, headerView.frame.size.height);
    } completion:nil];
    
    // animate the collection view away
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.collectionView.frame = CGRectMake(0, self.collectionView.frame.size.height, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
        self.headerCell.frame = CGRectMake(0, self.collectionView.frame.size.height, self.headerCell.frame.size.width, self.headerCell.frame.size.height);
        
        self.collectionView.alpha = 0;
        self.headerCell.alpha = 0;
    } completion:nil];
   
    // make the exercise view with no alpha and put it out of the view so we can animate these proporties
    DBWExercise *exercise = _workout.exercises[indexPath.row];
    DBWExerciseCollectionViewController *exercisesViewController = [[DBWExerciseCollectionViewController alloc] initWithExercise:exercise exerciseNumber:indexPath.row + 1];
    exercisesViewController.view.backgroundColor = [UIColor clearColor];
    exercisesViewController.collectionView.backgroundColor = [UIColor clearColor];
    exercisesViewController.collectionView.alpha = 0;
    exercisesViewController.headerCell.alpha = 0;
    exercisesViewController.collectionView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    // get rid of the shadow and transform. make it looked like its placed. then replace it with the same exact header in the new view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        anim.fromValue = @0.18;
        anim.toValue = @0;
        anim.duration = 0.4;
        [headerView.layer addAnimation:anim forKey:@"shadowOpacity"];
	headerView.layer.shadowOpacity = 0.0;
        [UIView animateWithDuration:0.4 animations:^{
            headerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [headerView removeFromSuperview];
            exercisesViewController.headerCell.alpha = 1;
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
            exercisesViewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [exercisesViewController willMoveToParentViewController:nil];
            [self.navigationController pushViewController:exercisesViewController animated:nil];
        }];
    });
    
}

@end
