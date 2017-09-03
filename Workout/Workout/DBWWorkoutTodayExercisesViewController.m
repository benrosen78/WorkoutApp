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
#import "DBWExerciseCollectionViewCell.h"
#import "DBWExerciseTableViewController.h"

@interface DBWWorkoutTodayExercisesViewController ()

@property (strong, nonatomic) DBWWorkout *workout;

@end

@implementation DBWWorkoutTodayExercisesViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithWorkout:(DBWWorkout *)workout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 50, 68);
    flowLayout.minimumLineSpacing = 1;
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        _workout = workout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[DBWExerciseCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
    
    DBWExerciseTableViewController *exerciseTableViewController = [[DBWExerciseTableViewController alloc] initWithExercise:_workout.exercises[indexPath.row]];
    [self.navigationController pushViewController:exerciseTableViewController animated:YES];
}

@end
