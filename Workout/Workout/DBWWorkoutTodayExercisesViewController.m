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
#import "DBWExercisePlaceholder.h"

@interface DBWWorkoutTodayExercisesViewController () <UIViewControllerPreviewingDelegate>

@end

@implementation DBWWorkoutTodayExercisesViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithWorkout:(DBWWorkout *)workout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 25, 68);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(140, 0, 25, 0);
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        _workout = workout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    
    self.title = @"Today's Gains";
    
    _headerCell = [[DBWWorkoutPlanDayCell alloc] init];
    _headerCell.layer.cornerRadius = 8;
    _headerCell.alpha = _headerCellAlpha;
    _headerCell.layer.masksToBounds = YES;
    _headerCell.backgroundColor = [UIColor whiteColor];
    _headerCell.titleLabel.text = [NSString stringWithFormat:@"Day %lu", _workout.templateDay];
    _headerCell.detailLabel.text = _workout.comments;
    _headerCell.color = [UIColor calendarColors][_workout.selectedColorIndex];
    _headerCell.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView addSubview:_headerCell];
    
    [_headerCell.topAnchor constraintEqualToAnchor:self.collectionView.safeAreaLayoutGuide.topAnchor constant:14].active = YES;
    [_headerCell.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:12.5].active = YES;
    [_headerCell.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-12.5].active = YES;
    [_headerCell.heightAnchor constraintEqualToConstant:105].active = YES;

    
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.hidesBackButton = YES;
    [self.collectionView registerClass:[DBWExerciseCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)setHeaderCellAlpha:(CGFloat)headerCellAlpha {
    _headerCellAlpha = headerCellAlpha;
    _headerCell.alpha = _headerCellAlpha;
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
    
    DBWExercise *exercise = _workout.exercises[indexPath.row];
    
    DBWExerciseCollectionViewController *exercisesViewController = [[DBWExerciseCollectionViewController alloc] initWithExercise:exercise exerciseNumber:indexPath.row + 1];
    [self.navigationController pushViewController:exercisesViewController animated:YES];
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
    return exercisesViewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
}

@end
