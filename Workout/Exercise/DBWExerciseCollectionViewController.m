//
//  DBWExerciseCollectionViewController.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseCollectionViewController.h"
#import "DBWExercise.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWSet.h"
#import "DBWDatabaseManager.h"
#import "DBWExerciseCollectionViewCell.h"
#import "DBWExerciseSetCollectionViewCell.h"
#import "DBWExercisePlaceholder.h"
#import "DBWExerciseCurrentSetsViewController.h"
#import "UIColor+ColorPalette.h"
#import "DBWExercisePastSetsViewController.h"

static NSString *const kCellIdentifier = @"set-cell-identifier";

@interface DBWExerciseCollectionViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) DBWExercise *exercise;

@property (nonatomic) NSInteger exerciseNumber;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIBarButtonItem *plusButtonItem;

@end

@implementation DBWExerciseCollectionViewController

- (instancetype)initWithExercise:(DBWExercise *)exercise exerciseNumber:(NSInteger)number {
    self = [super init];
    if (self) {
        _exercise = exercise;
        _exerciseNumber = number;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.prefersLargeTitles = NO;
    self.title = [NSString stringWithFormat:@"Exercise %lu", _exerciseNumber];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _headerCell = [[DBWExerciseCollectionViewCell alloc] init];
    _headerCell.layer.cornerRadius = 8;
    _headerCell.layer.shadowRadius = 10;
    _headerCell.layer.shadowOffset = CGSizeMake(0, 0);
    _headerCell.layer.shadowOpacity = 0.0;
    _headerCell.backgroundColor = [UIColor whiteColor];
    _headerCell.titleLabel.text = _exercise.placeholder.name;
    _headerCell.detailLabel.text = [NSString stringWithFormat:@"%lu x %lu", _exercise.expectedSets, _exercise.expectedReps];
    _headerCell.numberLabel.text = [NSString stringWithFormat:@"%lu", _exerciseNumber];
    _headerCell.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_headerCell];
    
    [_headerCell.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:12.5].active = YES;
    [_headerCell.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-12.5].active = YES;
    [_headerCell.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:13].active = YES;
    [_headerCell.heightAnchor constraintEqualToConstant:68].active = YES;

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view insertSubview:_scrollView belowSubview:_headerCell];
    
    [_scrollView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [_scrollView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [_scrollView.topAnchor constraintEqualToAnchor:_headerCell.bottomAnchor constant:13].active = YES;
    [_scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;

    DBWExerciseCurrentSetsViewController *currentSetsViewController = [[DBWExerciseCurrentSetsViewController alloc] init];
    currentSetsViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    currentSetsViewController.exercise = _exercise;
    [self addChildViewController:currentSetsViewController];
    [self.scrollView addSubview:currentSetsViewController.view];
    [currentSetsViewController didMoveToParentViewController:self];

    [currentSetsViewController.view.leftAnchor constraintEqualToAnchor:_scrollView.contentLayoutGuide.leftAnchor constant:12.5].active = YES;
    [currentSetsViewController.view.widthAnchor constraintEqualToAnchor:_scrollView.frameLayoutGuide.widthAnchor constant:-25].active = YES;
    [currentSetsViewController.view.topAnchor constraintEqualToAnchor:_scrollView.frameLayoutGuide.topAnchor].active = YES;
    [currentSetsViewController.view.bottomAnchor constraintEqualToAnchor:_scrollView.frameLayoutGuide.bottomAnchor].active = YES;

    DBWExercisePastSetsViewController *pastSetsViewController = [[DBWExercisePastSetsViewController alloc] initWithExercisePlaceholder:_exercise.placeholder];
    pastSetsViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    [self addChildViewController:pastSetsViewController];
    [self.scrollView addSubview:pastSetsViewController.view];
    [pastSetsViewController didMoveToParentViewController:self];
    [pastSetsViewController.view.leftAnchor constraintEqualToAnchor:currentSetsViewController.view.rightAnchor constant:25].active = YES;
    [pastSetsViewController.view.rightAnchor constraintEqualToAnchor:_scrollView.contentLayoutGuide.rightAnchor constant:-12.5].active = YES;
    [pastSetsViewController.view.widthAnchor constraintEqualToAnchor:_scrollView.frameLayoutGuide.widthAnchor constant:-25].active = YES;
    [pastSetsViewController.view.topAnchor constraintEqualToAnchor:_scrollView.frameLayoutGuide.topAnchor].active = YES;
    [pastSetsViewController.view.bottomAnchor constraintEqualToAnchor:_scrollView.frameLayoutGuide.bottomAnchor].active = YES;
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.678 green:0.729 blue:0.757 alpha:1.00];
    _pageControl.currentPageIndicatorTintColor = [UIColor appTintColor];
    _pageControl.numberOfPages = 2;
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_pageControl];
    [_pageControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_pageControl.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    
    _plusButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:currentSetsViewController action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = _plusButtonItem;
}

- (void)add:(UIBarButtonItem *)item {
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    [_exercise.sets addObject:[DBWSet new]];
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.contentSize.width / 2;
    int page = floor((scrollView.contentOffset.x - width / 2) / width) + 1;
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_pageControl.currentPage) {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:_plusButtonItem animated:NO];
    }
}

@end
