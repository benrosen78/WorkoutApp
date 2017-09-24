//
//  DBWWorkoutCurrentSetsViewController.m
//  Workout
//
//  Created by Ben Rosen on 9/23/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutCurrentSetsViewController.h"
#import "DBWExerciseCollectionViewCell.h"
#import "DBWExercise.h"
#import "DBWExercisePlaceholder.h"
#import "DBWAnimationTransitionController.h"
#import "DBWAnimationTransitionMemory.h"
#import "DBWWorkout.h"
#import "DBWExerciseCollectionViewController.h"

@interface DBWWorkoutCurrentSetsViewController () <UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) DBWAnimationTransitionController *transitionController;

@end

@implementation DBWWorkoutCurrentSetsViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 50, 68);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 0, 25, 0);
    return [super initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    _transitionController = [[DBWAnimationTransitionController alloc] init];
    [self.collectionView registerClass:[DBWExerciseCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    cell.titleLabel.text = exercise.placeholder.name;
    cell.detailLabel.text = [NSString stringWithFormat:@"%lu x %lu", exercise.expectedSets, exercise.expectedReps];
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

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!indexPath) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    previewingContext.sourceRect = layoutAttributes.frame;
    
    DBWExercise *exercise = _workout.exercises[indexPath.row];
    DBWExerciseCollectionViewController *exercisesViewController = [[DBWExerciseCollectionViewController alloc] initWithExercise:exercise exerciseNumber:indexPath.row + 1];
    
    // even though they peek/pop to get into the view controller, they will be animated back so we must provide the frame
    [DBWAnimationTransitionMemory sharedInstance].originalCellFrame = [self.view convertRect:layoutAttributes.frame fromView:self.collectionView];
    return exercisesViewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
}
@end
