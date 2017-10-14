//
//  DBWStopwatchViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/26/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatchViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWStopwatchCircularCollectionViewLayout.h"
#import "DBWStopwatchCollectionViewCell.h"
#import "DBWStopwatchCircularCollectionViewLayoutAttributes.h"

static NSString *const kStopwatchCellIdentifier = @"stopwatch.cell.identifier";

@interface DBWStopwatchViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIImpactFeedbackGenerator *feedbackGenerator;

@property (strong, nonatomic) UIImageView *feedbackChevronImageView;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation DBWStopwatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.navigationController.navigationBar.prefersLargeTitles = NO;
    
    UILabel *detailTitleLabel = [[UILabel alloc] init];
    detailTitleLabel.text = @"Pick a stopwatch time and tap Start. If you would like to customize these, go to settings.";
    detailTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    detailTitleLabel.textAlignment = NSTextAlignmentCenter;
    detailTitleLabel.numberOfLines = 0;
    detailTitleLabel.adjustsFontSizeToFitWidth = YES;
    detailTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:detailTitleLabel];
    
    [detailTitleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20].active = YES;
    [detailTitleLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [detailTitleLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;

    
    DBWStopwatchCircularCollectionViewLayout *circularLayout = [[DBWStopwatchCircularCollectionViewLayout alloc] init];
    circularLayout.itemSize = CGSizeMake(100, 100);
    circularLayout.radius = (self.view.frame.size.width / 2) + 100;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:circularLayout];
    [_collectionView registerClass:[DBWStopwatchCollectionViewCell class] forCellWithReuseIdentifier:kStopwatchCellIdentifier];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
  //  _collectionView.layer.transform = CATransform3DConcat(_collectionView.layer.transform, CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0));
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:-230].active = YES;
    [_collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [_collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;

    _feedbackChevronImageView = [[UIImageView alloc] init];
    _feedbackChevronImageView.image = [UIImage imageNamed:@"stopwatcharrow"];
    _feedbackChevronImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_feedbackChevronImageView];
    
    [_feedbackChevronImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_feedbackChevronImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:300].active = YES;

    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DBWStopwatchCollectionViewCell *stopwatchCell = [collectionView dequeueReusableCellWithReuseIdentifier:kStopwatchCellIdentifier forIndexPath:indexPath];
    //stopwatchCell.timeLabel.layer.transform = CATransform3DConcat(stopwatchCell.timeLabel.layer.transform, CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0));

    stopwatchCell.timeLabel.text = @[@"1:00", @"1:15", @"1:30", @"1:45", @"2:00", @"2:30", @"2:45", @"3:00"][indexPath.row];
    return stopwatchCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        DBWStopwatchCircularCollectionViewLayoutAttributes *attributes = (DBWStopwatchCircularCollectionViewLayoutAttributes *)[_collectionView layoutAttributesForItemAtIndexPath:indexPath];
  
        if (attributes.angle > -0.1 && attributes.angle < 0.1 && ![indexPath isEqual:_currentIndexPath]) {
            _currentIndexPath = indexPath;
            [_feedbackGenerator impactOccurred];
        }
    }
}

@end
