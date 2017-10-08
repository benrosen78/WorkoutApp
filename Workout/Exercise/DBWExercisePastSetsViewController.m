
//
//  DBWExercisePastSetsViewController.m
//  Workout
//
//  Created by Ben Rosen on 9/25/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePastSetsViewController.h"
#import "DBWExercisePlaceholder.h"
#import "DBWDatabaseManager.h"
#import "DBWWorkout.h"
#import "DBWSet.h"
#import "DBWExercisePastSetsCollectionViewCell.h"
#import "DBWExerciseSetInformationCollectionViewCell.h"
#import <CompactConstraint/CompactConstraint.h>
#import "UIColor+ColorPalette.h"

@interface DBWExercisePastSetsViewController ()

@property (strong, nonatomic) DBWExercisePlaceholder *placeholder;

@property (strong, nonatomic) NSArray *exercises;

@end

@implementation DBWExercisePastSetsViewController

static NSString * const kDateHeaderCell = @"date.header.cell";
static NSString * const kSetCell = @"date.set.cell";

- (instancetype)initWithExercisePlaceholder:(DBWExercisePlaceholder *)placeholder {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        _placeholder = placeholder;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _exercises = [[DBWDatabaseManager sharedDatabaseManager] pastExercisesForPlaceholder:_placeholder];

    [self.collectionView registerClass:[DBWExercisePastSetsCollectionViewCell class] forCellWithReuseIdentifier:kDateHeaderCell];
    [self.collectionView registerClass:[DBWExerciseSetInformationCollectionViewCell class] forCellWithReuseIdentifier:kSetCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"show.more.footer"];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _exercises.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    DBWExercise *exercise = _exercises[section];
    return 1 + [exercise.sets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBWExercise *exercise = _exercises[indexPath.section];
    DBWWorkout *workout = exercise.workouts.firstObject;
    
    if (indexPath.row == 0) {
        DBWExercisePastSetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDateHeaderCell forIndexPath:indexPath];
        
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:workout.date];

        cell.dateLabel.text = [NSString stringWithFormat:@"%lu/%lu/%lu", components.month, components.day, components.year];
        cell.expectedDataLabel.text = [NSString stringWithFormat:@"Expected: %lu x %lu", exercise.expectedSets, exercise.expectedReps];
        
        UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        cell.layer.mask = shape;

        return cell;
    } else if (indexPath.row >= 1) {
        DBWExerciseSetInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSetCell forIndexPath:indexPath];
        
        DBWSet *set = exercise.sets[indexPath.row - 1];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 20;
    
        cell.textLabel.text = [NSString stringWithFormat:@"Weight: %@\nReps: %lu", [formatter stringFromNumber:@(set.weight)], set.reps];
        cell.numberLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row];
        
        if (indexPath.row == [exercise.sets count]) {
            UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(8, 8)];
            CAShapeLayer *shape = [[CAShapeLayer alloc] init];
            [shape setPath:rounded.CGPath];
            cell.layer.mask = shape;
        } else {
            cell.layer.mask = nil;
        }
        
        return cell;
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [_exercises count] - 1 && kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"show.more.footer" forIndexPath:indexPath];
        
        UIButton *seeMoreButton = [footerView viewWithTag:999] ?: [[UIButton alloc] init];
        seeMoreButton.tag = 999;
        seeMoreButton.backgroundColor = [UIColor appTintColor];
        [seeMoreButton addTarget:self action:@selector(showMoreResults) forControlEvents:UIControlEventTouchUpInside];
        [seeMoreButton setTitle:@"Show more" forState:UIControlStateNormal];
        seeMoreButton.layer.masksToBounds = YES;
        seeMoreButton.layer.cornerRadius = 8;
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = NO;
        [footerView addSubview:seeMoreButton];
        [footerView addCompactConstraints:@[@"seeMore.centerX = view.centerX",
                                            @"seeMore.top = view.top",
                                            @"seeMore.width = 110",
                                            @"seeMore.height = 38"]
                                  metrics:nil
                                    views:@{@"seeMore": seeMoreButton,
                                            @"view": footerView
                                            }];
        return footerView;
    } else {
        return [UICollectionReusableView new];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return section == [_exercises count] - 1 ? CGSizeMake(self.view.frame.size.width, 94): CGSizeZero;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width - 50, indexPath.row == 0 ? 80 : 64);
}

- (void)showMoreResults {
   // _exercises = [[DBWDatabaseManager sharedDatabaseManager] exercisesForPlaceholder:_placeholder count:5 lastExercise:[_exercises lastObject]];
    [self.collectionView reloadData];
}

@end
