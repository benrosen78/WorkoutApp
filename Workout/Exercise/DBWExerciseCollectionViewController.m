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
#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import "DBWExerciseDetailDelegate.h"
#import "DBWExerciseDetailNavigationTitleView.h"

static NSString *const kCellIdentifier = @"set-cell-identifier";

@interface DBWExerciseCollectionViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, DBWExerciseDetailDelegate>

@property (strong, nonatomic) DBWExercise *exercise;

@property (nonatomic) NSInteger exerciseNumber;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIBarButtonItem *plusButtonItem;

@property (strong, nonatomic) NSLayoutConstraint *headerCellTopConstraint, *headerCellLeftConstraint;

@property (strong, nonatomic) NSArray<UICollectionViewController *> *viewControllers;

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

    // setup the magic class for the navigation bar title view - DBWExerciseDetailNavigationTitleView
    DBWExerciseDetailNavigationTitleView *navTitleView = [[DBWExerciseDetailNavigationTitleView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    navTitleView.titleLabelText = [NSString stringWithFormat:@"Exercise %lu", _exerciseNumber];
    navTitleView.detailTitleLabelText =  [NSString stringWithFormat:@"%@ %lu x %lu", _exercise.placeholder.name, _exercise.expectedSets, _exercise.expectedReps];
    self.navigationItem.titleView = navTitleView;
    
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    self.title = [NSString stringWithFormat:@"Exercise %lu", _exerciseNumber];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];

    [_scrollView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [_scrollView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [_scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [_scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;

    DBWExerciseCurrentSetsViewController *currentSetsViewController = [[DBWExerciseCurrentSetsViewController alloc] init];
    currentSetsViewController.delegate = self;
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
    pastSetsViewController.delegate = self;

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
    
    _headerCell = [[DBWExerciseCollectionViewCell alloc] init];
    _headerCell.backgroundColor = [UIColor whiteColor];
    _headerCell.titleLabel.text = _exercise.placeholder.name;
    _headerCell.detailLabel.text = [NSString stringWithFormat:@"%lu x %lu", _exercise.expectedSets, _exercise.expectedReps];
    _headerCell.numberLabel.text = [NSString stringWithFormat:@"%lu", _exerciseNumber];
    _headerCell.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:_headerCell];
    
    _headerCellLeftConstraint = [_headerCell.leftAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leftAnchor];
    _headerCellLeftConstraint.active = YES;
    
    [_headerCell.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;
    _headerCellTopConstraint = [_headerCell.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor];
    _headerCellTopConstraint.active = YES;
    [_headerCell.heightAnchor constraintEqualToConstant:68].active = YES;
    
    _plusButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:currentSetsViewController action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = _plusButtonItem;
    
    _viewControllers = @[currentSetsViewController, pastSetsViewController];
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
    
    CGFloat xOffset = scrollView.contentOffset.x;
    _headerCellLeftConstraint.constant = xOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_pageControl.currentPage) {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:_plusButtonItem animated:NO];
    }

    UICollectionViewController *selectedPage = _viewControllers[_pageControl.currentPage];
    [self updateViewsForViewOffsets:selectedPage animated:YES];
}

#pragma mark - DBWExerciseDetailDelegate

- (void)exerciseDetailViewControllerScrolled:(UICollectionViewController *)collectionViewController {
    [self updateViewsForViewOffsets:collectionViewController animated:NO];
}

- (void)updateViewsForViewOffsets:(UICollectionViewController *)collectionViewController animated:(BOOL)animated {
    CGFloat yOffset = collectionViewController.collectionView.contentOffset.y;
    
    if (yOffset > 0) {
        _headerCellTopConstraint.constant = -yOffset;
    } else {
        _headerCellTopConstraint.constant = 0;
    }
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    if (yOffset > 68) {
        DBWExerciseDetailNavigationTitleView *titleView = (DBWExerciseDetailNavigationTitleView *)self.navigationItem.titleView;
        [titleView animateToState:DBWExerciseTitleViewAnimationExpandedState];
    } else {
        DBWExerciseDetailNavigationTitleView *titleView = (DBWExerciseDetailNavigationTitleView *)self.navigationItem.titleView;
        [titleView animateToState:DBWExerciseTitleViewAnimationCondensedState];
        
    }
}



@end
