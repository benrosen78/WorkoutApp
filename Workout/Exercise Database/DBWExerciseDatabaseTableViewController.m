//
//  DBWExerciseDatabaseTableViewController.m
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseDatabaseTableViewController.h"
#import "DBWDatabaseManager.h"
#import "DBWExercisePlaceholder.h"
#import "DBWExerciseDatabase.h"
#import "DBWExerciseDatabaseConfirmationViewController.h"
#import "DBWExercisePlaceholderCreationViewController.h"
#import "DBWExercisePlaceholderCreationParentDelegate.h"

static NSString *const kCellIdentifier = @"exercise-placeholder-cell";

typedef NS_ENUM(NSInteger, DBWExerciseDatabaseCreationState) {
    DBWExerciseDatabaseCreationExpandedState,
    DBWExerciseDatabaseCreationCondensedState
};

@interface DBWExerciseDatabaseTableViewController () <DBWExercisePlaceholderCreationParentDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) DBWExerciseDatabase *exerciseDatabasePlaceholders;

@property (strong, nonatomic) RLMResults *filteredExercisePlaceholders;

@property (strong, nonatomic) UIVisualEffectView *blurredBackgroundView;

@property (nonatomic) DBWExercisePlaceholderType currentFilterType;

@property (nonatomic) DBWExerciseDatabaseCreationState creationState;

@property (strong, nonatomic) NSMutableArray<UIViewPropertyAnimator *> *animators;

@property (strong, nonatomic) DBWExercisePlaceholderCreationViewController *creationViewController;

@property (nonatomic) CGFloat progressWhenInterrupted;

@end

@implementation DBWExerciseDatabaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _exerciseDatabasePlaceholders = [[DBWDatabaseManager sharedDatabaseManager] allExercisePlaceholders];
    _filteredExercisePlaceholders = [_exerciseDatabasePlaceholders.list objectsWithPredicate:[NSPredicate predicateWithFormat:@"type == 0"]];
    _currentFilterType = DBWExercisePlaceholderChestType;
    
    self.title = @"Exercise Database";
    
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Chest", @"Back", @"Shoulders", @"Core", @"Arms", @"Legs"]];
    [segmentedControl setSelectedSegmentIndex:_currentFilterType];
    self.tableView.tableHeaderView = segmentedControl;
    [segmentedControl addTarget:self action:@selector(filterChanged:) forControlEvents:UIControlEventValueChanged];

    _animators = [NSMutableArray array];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.definesPresentationContext = YES;
    searchController.searchResultsUpdater = self;
    searchController.delegate = self;
    searchController.obscuresBackgroundDuringPresentation = NO;
    searchController.searchBar.placeholder = @"Search Exercise Database";
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExercise:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
}

- (void)cancelTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)filterChanged:(UISegmentedControl *)control {
    _currentFilterType = control.selectedSegmentIndex;
    _filteredExercisePlaceholders = [_exerciseDatabasePlaceholders.list objectsWithPredicate:[NSPredicate predicateWithFormat:@"type == %lu", _currentFilterType]];
    [self.tableView reloadData];
}

- (void)addExercise:(UIBarButtonItem *)sender {
    self.tableView.userInteractionEnabled = NO;
    
    _blurredBackgroundView = [[UIVisualEffectView alloc] init];
    _blurredBackgroundView.alpha = 0.9;
    _blurredBackgroundView.frame = self.view.frame;
    [self.navigationController.view addSubview:_blurredBackgroundView];
    
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss:)];
    [self.navigationController.view addGestureRecognizer:backgroundTap];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerPanned:)];

    [self.navigationController.view addGestureRecognizer:backgroundTap];
    [self.navigationController.view addGestureRecognizer:panGestureRecognizer];

    _creationViewController = [[DBWExercisePlaceholderCreationViewController alloc] init];
    _creationViewController.delegate = self;
    [self.navigationController addChildViewController:_creationViewController];
    [self.navigationController.view addSubview:_creationViewController.view];
    _creationViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 460);
    [_creationViewController didMoveToParentViewController:self];
    
    [[[UIViewPropertyAnimator alloc] initWithDuration:0.4 dampingRatio:0.8 animations:^{
        _creationViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 460, [[UIScreen mainScreen] bounds].size.width, 460);
    }] startAnimation];
    
    UICubicTimingParameters *blurTimingParameters = [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.3, 0.1) controlPoint2:CGPointMake(0.5, 0.25)];
    UIViewPropertyAnimator *blurAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.3 timingParameters:blurTimingParameters];
    [blurAnimator addAnimations:^{
        _blurredBackgroundView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }];
    [blurAnimator startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filteredExercisePlaceholders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    DBWExercisePlaceholder *placeholder = _filteredExercisePlaceholders[indexPath.row];
    cell.textLabel.text = placeholder.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBWExercisePlaceholder *placeholder = _filteredExercisePlaceholders[indexPath.row];
    
    DBWExerciseDatabaseConfirmationViewController *confirmationViewController = [[DBWExerciseDatabaseConfirmationViewController alloc] init];
    confirmationViewController.title = placeholder.name;
    confirmationViewController.selectedPlaceholder = placeholder;
    confirmationViewController.delegate = _delegate;
    [self.navigationController pushViewController:confirmationViewController animated:YES];
}

#pragma mark - DBWExercisePlaceholderCreationParentDelegate

- (void)creationViewController:(DBWExercisePlaceholderCreationViewController *)creationViewController changedToHeight:(CGFloat)height {
    creationViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - height, [[UIScreen mainScreen] bounds].size.width, height);
}

- (void)creationViewController:(DBWExercisePlaceholderCreationViewController *)creationViewController finishedWithMuscleGroup:(DBWExercisePlaceholderType)group andExerciseName:(NSString *)name {
    self.tableView.userInteractionEnabled = YES;
    
    _currentFilterType = group;
    _filteredExercisePlaceholders = [_exerciseDatabasePlaceholders.list objectsWithPredicate:[NSPredicate predicateWithFormat:@"type == %lu", group]];
    [self.tableView reloadData];
    ((UISegmentedControl *)self.tableView.tableHeaderView).selectedSegmentIndex = _currentFilterType;

    DBWExercisePlaceholderCreationViewController *__block localCreationViewController = creationViewController;
    UIViewPropertyAnimator *creationViewAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.4 dampingRatio:0.8 animations:^{
        localCreationViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 460);
    }];
    [creationViewAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [localCreationViewController.view removeFromSuperview];
        [localCreationViewController willMoveToParentViewController:nil];
        
        [localCreationViewController removeFromParentViewController];
        localCreationViewController = nil;
        
        DBWExercisePlaceholder *exercisePlaceholder = [[DBWExercisePlaceholder alloc] init];
        exercisePlaceholder.type = group;
        exercisePlaceholder.name = name;
        [[DBWDatabaseManager sharedDatabaseManager] saveNewExercisePlaceholder:exercisePlaceholder];
        [self.tableView reloadData];
        
    }];
    [creationViewAnimator startAnimation];
    
    UICubicTimingParameters *blurTimingParameters = [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.3, 0.25) controlPoint2:CGPointMake(0.5, 0.1)];
    UIViewPropertyAnimator *blurAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.3 timingParameters:blurTimingParameters];
    [blurAnimator addAnimations:^{
        _blurredBackgroundView.effect = nil;
    }];
    [blurAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [_blurredBackgroundView removeFromSuperview];
        _blurredBackgroundView = nil;
    }];
    [blurAnimator startAnimation];
    
    _creationState = [self nextCreationState];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    _filteredExercisePlaceholders = [_exerciseDatabasePlaceholders.list objectsWithPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@ && type == %lu", searchController.searchBar.text, _currentFilterType]];
    [self.tableView reloadData];
}

#pragma mark - Gesture Animations

- (void)tapDismiss:(UITapGestureRecognizer *)recognizer {
    
}

- (void)gestureRecognizerPanned:(UIPanGestureRecognizer *)recognizer {
    CGPoint p = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self startInteractiveTransition:[self nextCreationState]];
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:[self percentageCompleteForState:[self nextCreationState] translation:[recognizer translationInView:self.view]]];
            break;
        case UIGestureRecognizerStateEnded:
            [self continueInteractiveTransition:[self percentageCompleteForState:[self nextCreationState] translation:[recognizer translationInView:self.view]]];
            break;
        default:
            break;
    }
}

- (void)startInteractiveTransition:(DBWExerciseDatabaseCreationState)state {
    [self addAnimatorsIfNeeded:state];
}

- (void)updateInteractiveTransition:(CGFloat)percentageComplete {
    for (UIViewPropertyAnimator *animator in _animators) {
        animator.fractionComplete = percentageComplete;
    }
}

- (void)addAnimatorsIfNeeded:(DBWExerciseDatabaseCreationState)state {
    if (_animators.count == 0) {
        [self animateFrames:state];
        [self animateBlur:state];
    }
    for (UIViewPropertyAnimator *animator in _animators) {
        [animator pauseAnimation];
    }
    _progressWhenInterrupted = _animators[0].fractionComplete ?: 0;
}

- (DBWExerciseDatabaseCreationState)nextCreationState {
    switch (_creationState) {
        case DBWExerciseDatabaseCreationExpandedState:
            return DBWExerciseDatabaseCreationCondensedState;
        case DBWExerciseDatabaseCreationCondensedState:
            return DBWExerciseDatabaseCreationExpandedState;
    }
}

- (CGFloat)percentageCompleteForState:(DBWExerciseDatabaseCreationState)state translation:(CGPoint)translation {
    CGFloat translationY = state == DBWExerciseDatabaseCreationExpandedState ? -translation.y : translation.y;
    return (translationY / _creationViewController.view.frame.size.height) + _progressWhenInterrupted;
}

- (void)continueInteractiveTransition:(CGFloat)percentageCompleted {
    if (percentageCompleted < 0.4) {
        for (UIViewPropertyAnimator *animator in _animators) {
            animator.reversed = !animator.reversed;
            [animator continueAnimationWithTimingParameters:nil durationFactor:0];
        }
    } else {
        UICubicTimingParameters *curvedTimingParameters = [[UICubicTimingParameters alloc] initWithAnimationCurve:UIViewAnimationCurveEaseOut];
        for (UIViewPropertyAnimator *animator in _animators) {
            [animator continueAnimationWithTimingParameters:curvedTimingParameters durationFactor:0];
        }
    }
}

- (void)animateFrames:(DBWExerciseDatabaseCreationState)state {
    UIViewPropertyAnimator *creationViewAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.4 dampingRatio:0.8 animations:^{
        _creationViewController.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 460);
    }];
    [creationViewAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (finalPosition == UIViewAnimatingPositionEnd) {
            [_creationViewController.view removeFromSuperview];
            [_creationViewController willMoveToParentViewController:nil];
        
            [_creationViewController removeFromParentViewController];
            _creationViewController = nil;
            _creationState = [self nextCreationState];
        }
        self.animators = [NSMutableArray array];
    }];
    [_animators addObject:creationViewAnimator];
}

- (void)animateBlur:(DBWExerciseDatabaseCreationState)state {
    UICubicTimingParameters *blurTimingParameters = [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.25, 0.3) controlPoint2:CGPointMake(0.1, 0.5)];
    UIViewPropertyAnimator *blurAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.3 timingParameters:blurTimingParameters];
    blurAnimator.scrubsLinearly = NO;
    [blurAnimator addAnimations:^{
        _blurredBackgroundView.alpha = 0;
    }];
    [_animators addObject:blurAnimator];

}

@end
