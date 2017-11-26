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
#import "DBWStopwatchActiveViewController.h"
#import "DBWDatabaseManager.h"
#import "DBWStopwatchList.h"
#import "DBWStopwatch.h"

static NSString *const kStopwatchCellIdentifier = @"stopwatch.cell.identifier";

@interface DBWStopwatchViewController () <UICollectionViewDelegate, UICollectionViewDataSource, DBWStopwatchCompletionDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UISelectionFeedbackGenerator *feedbackGenerator;

@property (strong, nonatomic) UIImageView *feedbackChevronImageView;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) DBWStopwatchList *stopwatchList;

// timing view controller
@property (strong, nonatomic) DBWStopwatchActiveViewController *currentActiveViewController;
// snapshot of current view, used for animations. will be nil otherwise
@property (strong, nonatomic) UIView *animationSnapshotView;

@property (strong, nonatomic) NSLayoutConstraint *stackViewTopConstraint, *stackViewBottomConstraint;

@property (nonatomic) NSString *minutes, *seconds;

@end

@implementation DBWStopwatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stopwatchList = [[DBWDatabaseManager sharedDatabaseManager] stopwatchList];
    
    _feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
    
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
    [detailTitleLabel.heightAnchor constraintEqualToConstant:40].active = YES;

    [detailTitleLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [detailTitleLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;

    
    DBWStopwatchCircularCollectionViewLayout *circularLayout = [[DBWStopwatchCircularCollectionViewLayout alloc] init];
    circularLayout.itemSize = CGSizeMake(100, 100);
    circularLayout.radius = (self.view.frame.size.width / 2) + 120;
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
    
    [_collectionView.topAnchor constraintEqualToAnchor:detailTitleLabel.bottomAnchor constant:60].active = YES;
    [_collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [_collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;

    _feedbackChevronImageView = [[UIImageView alloc] init];
    _feedbackChevronImageView.tintColor = [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00];
    _feedbackChevronImageView.image = [[UIImage imageNamed:@"stopwatcharrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _feedbackChevronImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_feedbackChevronImageView];
    
    [_feedbackChevronImageView.heightAnchor constraintEqualToConstant:_feedbackChevronImageView.image.size.height].active = YES;
    [_feedbackChevronImageView.widthAnchor constraintEqualToConstant:_feedbackChevronImageView.image.size.width].active = YES;

    [_feedbackChevronImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_feedbackChevronImageView.topAnchor constraintEqualToAnchor:self.collectionView.topAnchor constant:circularLayout.itemSize.height + 22].active = YES;

    UIStackView *bottomStackView = [[UIStackView alloc] init];
    bottomStackView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    bottomStackView.spacing = 15;
    bottomStackView.distribution = UIStackViewDistributionEqualSpacing;
    bottomStackView.axis = UILayoutConstraintAxisVertical;
    bottomStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bottomStackView];
    
    _stackViewTopConstraint = [bottomStackView.topAnchor constraintEqualToAnchor:_feedbackChevronImageView.bottomAnchor constant:60];
    _stackViewTopConstraint.active = YES;
    [bottomStackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [bottomStackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    _stackViewBottomConstraint = [bottomStackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-100];
    _stackViewBottomConstraint.active = YES;
    
 
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
    customTextField.delegate = self;
    customTextField.keyboardType = UIKeyboardTypeNumberPad;
    NSMutableAttributedString *textFieldPlaceholderAttibute = [[NSMutableAttributedString alloc] initWithString:@"m" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}];
    [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" : " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
     [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"ss" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}]];

    
    customTextField.attributedPlaceholder = textFieldPlaceholderAttibute;
    customTextField.font = [UIFont systemFontOfSize:36 weight:UIFontWeightMedium];
    customTextField.textAlignment = NSTextAlignmentCenter;
    customTextField.tintColor = [UIColor clearColor];
    [bottomStackView addArrangedSubview:customTextField];

    [customTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;

    UIButton *startButton = [[UIButton alloc] init];
    [startButton addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DBWStopwatchCollectionViewCell *stopwatchCell = [collectionView dequeueReusableCellWithReuseIdentifier:kStopwatchCellIdentifier forIndexPath:indexPath];
    
    CGFloat h, s, b, a;
    [[UIColor appTintColor] getHue:&h saturation:&s brightness:&b alpha:&a];
    UIColor *cellColor = [[UIColor alloc] initWithHue:h saturation:s brightness:0.33 + (indexPath.row / 20.0) alpha:a];
    
    stopwatchCell.backgroundColor = cellColor;

    DBWStopwatch *cellStopwatch = _stopwatchList.list[indexPath.row];
    stopwatchCell.timeLabel.text = cellStopwatch.formattedTimeString;
    return stopwatchCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_stopwatchList.list count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        DBWStopwatchCircularCollectionViewLayoutAttributes *attributes = (DBWStopwatchCircularCollectionViewLayoutAttributes *)[_collectionView layoutAttributesForItemAtIndexPath:indexPath];
  
        if (attributes.angle > -0.05 && attributes.angle < 0.05 && ![indexPath isEqual:_currentIndexPath]) {
            _currentIndexPath = indexPath;
            [_feedbackGenerator selectionChanged];
            _feedbackChevronImageView.transform = CGAffineTransformMakeTranslation(0, -10);
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity: 0.0 options:kNilOptions animations:^{
                _feedbackChevronImageView.transform = CGAffineTransformIdentity;
            } completion:nil];
            
        }
    }
}

- (void)startTimer {
    _animationSnapshotView = [self.view snapshotViewAfterScreenUpdates:NO];
    [self.view addSubview:_animationSnapshotView];

    [UIView animateWithDuration:0.3 animations:^{
        _animationSnapshotView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        _animationSnapshotView.alpha = 0;
    }];
    
    for (UIView *subview in self.view.subviews) {
        subview.alpha = 0;
    }
    
    DBWStopwatch *startingStopwatch = _stopwatchList.list[_currentIndexPath.row];
    if (_minutes && _seconds) {
        [self.view endEditing:YES];
        DBWStopwatch *stopwatch = [[DBWStopwatch alloc] init];
        stopwatch.minutes = [_minutes integerValue];
        stopwatch.seconds = [_seconds integerValue];
        startingStopwatch = stopwatch;
    }

    
    _currentActiveViewController = [[DBWStopwatchActiveViewController alloc] initWithStopwatch:startingStopwatch];
    _currentActiveViewController.delegate = self;
    [self addChildViewController:_currentActiveViewController];
    _currentActiveViewController.view.frame = self.view.frame;
    _currentActiveViewController.view.alpha = 0;
    _currentActiveViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);

    [self.view addSubview:_currentActiveViewController.view];
    [_currentActiveViewController didMoveToParentViewController:self];
    [UIView animateWithDuration:0.25 delay: 0.1 options:kNilOptions animations:^{
        _currentActiveViewController.view.transform = CGAffineTransformIdentity;
        _currentActiveViewController.view.alpha = 1;
    } completion:nil];
}

- (CGRect)getSelectedFrame {
    return CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - 50, _collectionView.frame.origin.y, 100, 100);
}

#pragma mark - DBWStopwatchCompletionDelegate

- (void)stopwatchCompleted {
    
    [UIView animateWithDuration:0.3 animations:^{
        _currentActiveViewController.view.alpha = 0;
        _currentActiveViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
    } completion:^(BOOL finished) {
        [_currentActiveViewController willMoveToParentViewController:nil];
        [_currentActiveViewController.view removeFromSuperview];
        [_currentActiveViewController removeFromParentViewController];
        _currentActiveViewController = nil;
    }];

    [UIView animateWithDuration:0.25 delay: 0.1 options:kNilOptions animations:^{
        _animationSnapshotView.transform = CGAffineTransformIdentity;
        _animationSnapshotView.alpha = 1;
    } completion:^(BOOL finished) {
        for (UIView *subview in self.view.subviews) {
            subview.alpha = 1;
        }
        _animationSnapshotView.alpha = 0;
        [_animationSnapshotView removeFromSuperview];
        _animationSnapshotView = nil;
    }];
    
}

#pragma mark - UIKeyboardWillChangeFrameNotification

- (void)keyboardNotification:(NSNotification *)notification {
    CGRect beforeKeyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect afterKeyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = beforeKeyboardSize.origin.y - afterKeyboardSize.origin.y;
    CGFloat constant = offset > 0 ? -100 : 100;
    _stackViewTopConstraint.constant -= offset + constant;
    _stackViewBottomConstraint.constant -= offset + constant;

    
    NSLog(@"offset = %f", offset);
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];

        if (offset > 0) {
            self.collectionView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.collectionView.center = CGPointMake(self.view.center.x, 280);
            self.collectionView.alpha = 0;
            
            _feedbackChevronImageView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            _feedbackChevronImageView.center = CGPointMake(self.view.center.x, 280);
            _feedbackChevronImageView.alpha = 0;
        } else {
            self.collectionView.transform = CGAffineTransformIdentity;
            self.collectionView.center = self.view.center;
            self.collectionView.alpha = 0;
            
            _feedbackChevronImageView.transform = CGAffineTransformIdentity;
            _feedbackChevronImageView.center = self.view.center;
            _feedbackChevronImageView.alpha = 0;
        }


    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        if (_seconds.length == 2) {
            _seconds = [_seconds substringToIndex:1];
            NSMutableAttributedString *textFieldPlaceholderAttibute = [[NSMutableAttributedString alloc] initWithString:_minutes attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" : " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[_seconds stringByAppendingString:@"s"] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}]];
            
            textField.attributedText = textFieldPlaceholderAttibute;

        } else if (_seconds) {
            
            
            NSMutableAttributedString *textFieldPlaceholderAttibute = [[NSMutableAttributedString alloc] initWithString:_minutes attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" : " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"ss" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}]];
            textField.attributedText = textFieldPlaceholderAttibute;

            
            _seconds = nil;
        } else if (_minutes) {
            _minutes = nil;
            NSMutableAttributedString *textFieldPlaceholderAttibute = [[NSMutableAttributedString alloc] initWithString:@"m" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" : " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"ss" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}]];
            
            
            textField.attributedText = textFieldPlaceholderAttibute;
        }
        return NO;
    }
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
        if (!_minutes) {
            NSMutableAttributedString *textFieldPlaceholderAttibute = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" : " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"ss" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}]];
            
            _minutes = string;
            textField.attributedText = textFieldPlaceholderAttibute;

        } else if (!_seconds) {
            NSInteger seconds = [string integerValue];
            if (seconds >= 6) {
                NSInteger minutesToAdd = seconds / 6;
                NSInteger secondsToAdd = seconds % 6;
                _minutes = [NSString stringWithFormat:@"%lu", [_minutes integerValue] + minutesToAdd];
                string = [NSString stringWithFormat:@"%lu", secondsToAdd];
            }
            NSMutableAttributedString *textFieldPlaceholderAttibute = [[NSMutableAttributedString alloc] initWithString:_minutes attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" : " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[string stringByAppendingString:@"s"] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00]}]];
            
            _seconds = string;
            textField.attributedText = textFieldPlaceholderAttibute;

        } else if (_seconds.length == 1) {
            NSMutableAttributedString *textFieldPlaceholderAttibute = [[NSMutableAttributedString alloc] initWithString:_minutes attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" : " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
            [textFieldPlaceholderAttibute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[_seconds stringByAppendingString:string] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]];
            
            _seconds = [_seconds stringByAppendingString:string];
            textField.attributedText = textFieldPlaceholderAttibute;
        }

        
        
        return NO;
    } else {
        return NO;
        
    }

    return YES;
}

@end
