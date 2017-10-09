//
//  DBWExerciseCurrentSetsViewController.m
//  Workout
//
//  Created by Ben Rosen on 9/23/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseCurrentSetsViewController.h"
#import "DBWExercise.h"
#import "DBWExerciseCollectionViewCell.h"
#import "DBWExercisePlaceholder.h"
#import "DBWExerciseSetCollectionViewCell.h"
#import "DBWSet.h"
#import "DBWDatabaseManager.h"

static NSString *const kCellIdentifier = @"set-cell-identifier";

@interface DBWExerciseCurrentSetsViewController () <UITextFieldDelegate>

@property (nonatomic) NSInteger exerciseNumber;

@end

@implementation DBWExerciseCurrentSetsViewController

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 25
                                     , 100);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 15, 0);
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
    //    _exercise = exercise;
     //   _exerciseNumber = number;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    self.title = [NSString stringWithFormat:@"Exercise %lu", _exerciseNumber];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    [self.collectionView registerClass:[DBWExerciseSetCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
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
    
    UITableViewCell *cell = (UICollectionViewCell *)textField.superview.superview.superview;
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    DBWSet *set = _exercise.sets[path.row];
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

@end
