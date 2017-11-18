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

static NSString *const kCellIdentifier = @"set-cell-identifier";

@interface DBWExerciseCollectionViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, DBWExerciseDetailDelegate>

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
    UILabel *titleLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100) /* auto-sized anyway */];
    titleLabelView.backgroundColor = [UIColor clearColor];
    titleLabelView.textAlignment = NSTextAlignmentCenter;
    titleLabelView.textColor = [UIColor blackColor];
    titleLabelView.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    titleLabelView.adjustsFontSizeToFitWidth = YES;
    titleLabelView.text = self.title;
    self.navigationItem.titleView = titleLabelView;

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];

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
    [currentSetsViewController.collectionView addSubview:_headerCell];
    [_headerCell.leftAnchor constraintEqualToAnchor:currentSetsViewController.view.leftAnchor].active = YES;
    [_headerCell.rightAnchor constraintEqualToAnchor:currentSetsViewController.view.rightAnchor].active = YES;
    [_headerCell.topAnchor constraintEqualToAnchor:currentSetsViewController.collectionView.contentLayoutGuide.topAnchor].active = YES;
    [_headerCell.heightAnchor constraintEqualToConstant:68].active = YES;
    
    
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
    
/*
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.navigationItem.titleView.layer addAnimation:animation forKey:@"changeTitle"];
    
    ((UILabel*)self.navigationItem.titleView).text = @"JACOB K";*/
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_pageControl.currentPage) {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:_plusButtonItem animated:NO];
    }
}

#pragma mark - DBWExerciseDetailDelegate
BOOL doneAlready = NO;
- (void)exerciseDetailViewControllerScrolled:(UICollectionViewController *)collectionViewController {
    NSLog(@"current offset: %@", NSStringFromCGPoint(collectionViewController.collectionView.contentOffset));
    CGFloat yOffset = collectionViewController.collectionView.contentOffset.y;
    
    if (yOffset >= 68 && !doneAlready) {
        ((UILabel*)self.navigationItem.titleView).alpha = 0;

        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.navigationItem.titleView.layer addAnimation:animation forKey:@"changeTitle"];
        doneAlready = YES;
        ((UILabel*)self.navigationItem.titleView).text = _exercise.placeholder.name;
        ((UILabel*)self.navigationItem.titleView).alpha = 1.0;

        
    } else if (yOffset <= 0) {
        CATransition *animation = [CATransition animation];
        animation.duration = 1.0;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.navigationItem.titleView.layer addAnimation:animation forKey:@"changeTitle"];
        
        ((UILabel*)self.navigationItem.titleView).text = @"JACOB K";
    }
}

@end
