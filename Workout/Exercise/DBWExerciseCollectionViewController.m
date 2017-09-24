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
#import "DBWAnimationDismissTransitionController.h"
#import "DBWAnimationTransitionMemory.h"
#import "DBWExercisePlaceholder.h"
#import "DBWExerciseCurrentSetsViewController.h"

static NSString *const kCellIdentifier = @"set-cell-identifier";

@interface DBWExerciseCollectionViewController () <UITextFieldDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) DBWExercise *exercise;

@property (nonatomic) NSInteger exerciseNumber;

@property (strong, nonatomic) DBWAnimationDismissTransitionController *transitionController;

@end

@implementation DBWExerciseCollectionViewController

- (instancetype)initWithExercise:(DBWExercise *)exercise exerciseNumber:(NSInteger)number {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 50, 100);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(108, 0, 15, 0);
    self = [super init];
    if (self) {
        _exercise = exercise;
        _exerciseNumber = number;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _headerCell = [[DBWExerciseCollectionViewCell alloc] initWithFrame:CGRectMake(0, 135, self.view.frame.size.width - 50, 68)];
    _headerCell.center = CGPointMake(self.view.frame.origin.x, 0);
    _headerCell.layer.cornerRadius = 8;
    _headerCell.layer.shadowRadius = 10;
    _headerCell.layer.shadowOffset = CGSizeMake(0, 0);
    _headerCell.layer.shadowOpacity = 0.0;
    _headerCell.backgroundColor = [UIColor whiteColor];
    _headerCell.titleLabel.text = _exercise.placeholder.name;
    _headerCell.detailLabel.text = [NSString stringWithFormat:@"%lu x %lu", _exercise.expectedSets, _exercise.expectedReps];
    _headerCell.numberLabel.text = [NSString stringWithFormat:@"%lu", _exerciseNumber];
    [self.view addSubview:_headerCell];
 
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 245, self.view.frame.size.width, self.view.frame.size.height - 245);
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
  //  [self.view addSubview:_scrollView];
    
    self.title = [NSString stringWithFormat:@"Exercise %lu", _exerciseNumber];

    
    
    
    
    
    
    
    
    /*    _scrollView = [[UIScrollView alloc] init];
     _scrollView.frame = CGRectMake(0, 245, self.view.frame.size.width, self.view.frame.size.height - 135);
     _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height)
     */
     DBWExerciseCurrentSetsViewController *currentSetsViewController = [[DBWExerciseCurrentSetsViewController alloc] init];
     currentSetsViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 135);
     currentSetsViewController.exercise = _exercise;
     [self addChildViewController:currentSetsViewController];
     [self.scrollView addSubview:currentSetsViewController.view];
     [currentSetsViewController didMoveToParentViewController:self];
     
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    _transitionController = [[DBWAnimationDismissTransitionController alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // weird issue with 3d touch. would appear under the nav bar if the frame is not updated after it loads.
    //[self.headerCell removeFromSuperview];
    //self.headerCell.frame = CGRectMake(25, 20, self.view.frame.size.width - 50, 68);
    //self.headerCell.alpha = 1;
    
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [DBWAnimationTransitionMemory sharedInstance].popSnapshotCellView = self.headerCell;
}

- (void)add:(UIBarButtonItem *)item {
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    [_exercise.sets addObject:[DBWSet new]];
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
    //[DBWWorkoutManager saveWorkout:_exercise.workout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_exercise.sets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBWExerciseSetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    UITextField *weightTF = cell.textFields[0];
    UITextField *repsTF = cell.textFields[1];

    weightTF.delegate = self;
    repsTF.delegate = self;
    
    weightTF.tag = 1;
    repsTF.tag = 2;
    
    DBWSet *set = _exercise.sets[indexPath.row];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 20;
        
    weightTF.text = set.weight ? [NSString stringWithFormat:@"%@", [formatter stringFromNumber:@(set.weight)]] : @"";
    repsTF.text = set.reps ? [NSString stringWithFormat:@"%lu", set.reps] : @"";
    
    return cell;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
        [_exercise.sets removeObjectAtIndex:indexPath.section];
        [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return _transitionController;
}

@end
