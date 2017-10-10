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

static NSString *const kStopwatchCellIdentifier = @"stopwatch.cell.identifier";

@interface DBWStopwatchViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation DBWStopwatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    _collectionView.layer.transform = CATransform3DConcat(_collectionView.layer.transform, CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0));

    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView.topAnchor constraintEqualToAnchor:detailTitleLabel.bottomAnchor constant:150].active = YES;
    [_collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [_collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;

}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DBWStopwatchCollectionViewCell *stopwatchCell = [collectionView dequeueReusableCellWithReuseIdentifier:kStopwatchCellIdentifier forIndexPath:indexPath];
    return stopwatchCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

@end
