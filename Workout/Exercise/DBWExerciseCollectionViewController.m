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
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        _exercise = exercise;
        _exerciseNumber = number;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _headerCell = [[DBWExerciseCollectionViewCell alloc] initWithFrame:CGRectMake(25, 20, self.view.frame.size.width - 50, 68)];
    _headerCell.layer.cornerRadius = 8;
    _headerCell.layer.shadowRadius = 10;
    _headerCell.layer.shadowOffset = CGSizeMake(0, 0);
    _headerCell.layer.shadowOpacity = 0.0;
    _headerCell.backgroundColor = [UIColor whiteColor];
    _headerCell.titleLabel.text = _exercise.placeholder.name;
    _headerCell.detailLabel.text = [NSString stringWithFormat:@"%lu x %lu", _exercise.expectedSets, _exercise.expectedReps];
    _headerCell.numberLabel.text = [NSString stringWithFormat:@"%lu", _exerciseNumber];
    [self.collectionView addSubview:_headerCell];
 
    self.title = [NSString stringWithFormat:@"Exercise %lu", _exerciseNumber];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    [self.collectionView registerClass:[DBWExerciseSetCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    _transitionController = [[DBWAnimationDismissTransitionController alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // weird issue with 3d touch. would appear under the nav bar if the frame is not updated after it loads.
    [self.headerCell removeFromSuperview];
    self.headerCell.frame = CGRectMake(25, 20, self.view.frame.size.width - 50, 68);
    [self.collectionView addSubview:self.headerCell];
    self.headerCell.alpha = 1;
    
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    CGRect frame = [self.view convertRect:self.headerCell.frame fromView:self.collectionView];
    
    [self.headerCell removeFromSuperview];
    self.headerCell.frame = frame;
    [self.view addSubview:self.headerCell];
    [DBWAnimationTransitionMemory sharedInstance].popSnapshotCellView = self.headerCell;
}

- (void)add:(UIBarButtonItem *)item {
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    [_exercise.sets addObject:[DBWSet new]];
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
    //[DBWWorkoutManager saveWorkout:_exercise.workout];
    
    [self.collectionView reloadData];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview.superview;
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    DBWSet *set = _exercise.sets[path.section];
    if (textField.tag == 1) {
        set.weight = [newText floatValue];
    } else if (textField.tag == 2) {
        set.reps = [newText integerValue];
    }
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
    
    return YES;
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
