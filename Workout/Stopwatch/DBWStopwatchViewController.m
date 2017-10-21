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
#import "UIColor+ColorPalette.h"

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
    
    _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    
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
    
    [detailTitleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant: 15].active = YES;
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
    
    [_collectionView.topAnchor constraintEqualToAnchor:detailTitleLabel.bottomAnchor constant:15].active = YES;
    [_collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [_collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;

    _feedbackChevronImageView = [[UIImageView alloc] init];
    _feedbackChevronImageView.tintColor = [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00];
    _feedbackChevronImageView.image = [[UIImage imageNamed:@"stopwatcharrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _feedbackChevronImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_feedbackChevronImageView];
    
    [_feedbackChevronImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_feedbackChevronImageView.topAnchor constraintEqualToAnchor:self.collectionView.topAnchor constant:circularLayout.itemSize.height + 22].active = YES;

    UIStackView *bottomStackView = [[UIStackView alloc] init];
    bottomStackView.spacing = 60;
    bottomStackView.axis = UILayoutConstraintAxisVertical;
    bottomStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bottomStackView];
    
    [bottomStackView.topAnchor constraintEqualToAnchor:_feedbackChevronImageView.bottomAnchor constant:35].active = YES;
    [bottomStackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [bottomStackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [bottomStackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-bottomStackView.spacing].active = YES;
 
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00];
    [bottomStackView addArrangedSubview:separator];
    [separator.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:25].active = YES;
    [separator.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-25].active = YES;
    [separator.heightAnchor constraintEqualToConstant:1].active = YES;

    UILabel *orLabel = [[UILabel alloc] init];
    orLabel.textColor = separator.backgroundColor;
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.text = @"or";
    orLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    orLabel.backgroundColor = self.view.backgroundColor;
    orLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:orLabel];
    
    [orLabel.centerXAnchor constraintEqualToAnchor:separator.centerXAnchor].active = YES;
    [orLabel.centerYAnchor constraintEqualToAnchor:separator.centerYAnchor].active = YES;
    [orLabel.widthAnchor constraintEqualToConstant:35].active = YES;
    
    UITextField *customTextField = [[UITextField alloc] init];
    NSMutableAttributedString *textFieldPlaceholderAttibute = [[NSMutableAttributedString alloc] initWithString:@"m" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}];
    [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" : " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
     [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"ss" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}]];

    
    customTextField.attributedPlaceholder = textFieldPlaceholderAttibute;
    customTextField.font = [UIFont systemFontOfSize:36 weight:UIFontWeightMedium];
    customTextField.textAlignment = NSTextAlignmentCenter;
    [bottomStackView addArrangedSubview:customTextField];

    [customTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;

    UIButton *startButton = [[UIButton alloc] init];
    startButton.layer.masksToBounds = YES;
    startButton.layer.cornerRadius = 14;
    startButton.backgroundColor = [UIColor appTintColor];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomStackView addArrangedSubview:startButton];

    [startButton.heightAnchor constraintEqualToConstant:45].active = YES;
    [startButton.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:45].active = YES;
    [startButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-45].active = YES;
    

    
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
  
        if (attributes.angle > -0.05 && attributes.angle < 0.05 && ![indexPath isEqual:_currentIndexPath]) {
            _currentIndexPath = indexPath;
            [_feedbackGenerator impactOccurred];
            _feedbackChevronImageView.transform = CGAffineTransformMakeTranslation(0, -10);
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity: 0.0 options:kNilOptions animations:^{
                _feedbackChevronImageView.transform = CGAffineTransformIdentity;
            } completion:nil];
            
        }
    }
}

@end
