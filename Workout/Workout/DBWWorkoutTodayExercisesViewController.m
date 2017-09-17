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
#import "DBWAnimationTransitionController.h"
#import "DBWAnimationTransitionMemory.h"

@interface DBWWorkoutTodayExercisesViewController () <UINavigationControllerDelegate>

@property (strong, nonatomic) DBWWorkout *workout;

@property (strong, nonatomic) DBWAnimationTransitionController *transitionController;

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
    
    _transitionController = [[DBWAnimationTransitionController alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _headerCell.alpha = 1;
    _headerCell.frame = CGRectMake(25, 135, self.view.frame.size.width - 50, 110);
    [self.collectionView reloadData];
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
    cell.layer.cornerRadius = 0;
    cell.layer.masksToBounds = NO;

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
    
    _transitionController.snapshotCellView = headerView;
    [DBWAnimationTransitionMemory sharedInstance].originalCellFrame = headerView.frame;
    
    DBWExercise *exercise = _workout.exercises[indexPath.row];
    
    DBWExerciseCollectionViewController *exercisesViewController = [[DBWExerciseCollectionViewController alloc] initWithExercise:exercise exerciseNumber:indexPath.row + 1];
    [self.navigationController pushViewController:exercisesViewController animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return _transitionController;
}

@end
