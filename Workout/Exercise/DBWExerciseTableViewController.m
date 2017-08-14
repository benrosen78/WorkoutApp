//
//  DBWExerciseTableViewController.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseTableViewController.h"
#import "DBWExercise.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWSet.h"
#import "DBWExerciseSetTableViewCell.h"
#import "DBWDatabaseManager.h"

static NSString *const kCellIdentifier = @"set-cell-identifier";

@interface DBWExerciseTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) DBWExercise *exercise;

@end

@implementation DBWExerciseTableViewController

- (instancetype)initWithExercise:(DBWExercise *)exercise {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _exercise = exercise;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _exercise.name;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    [self.tableView registerClass:[DBWExerciseSetTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (void)add:(UIBarButtonItem *)item {
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    [_exercise.sets addObject:[DBWSet new]];
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
    //[DBWWorkoutManager saveWorkout:_exercise.workout];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_exercise.sets count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBWExerciseSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *weightTF = cell.textFields[0];
    UITextField *repsTF = cell.textFields[1];

    weightTF.delegate = self;
    repsTF.delegate = self;
    
    weightTF.tag = 1;
    repsTF.tag = 2;
    
    DBWSet *set = _exercise.sets[indexPath.section];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 20;
        
    weightTF.text = set.weight ? [NSString stringWithFormat:@"%@", [formatter stringFromNumber:@(set.weight)]] : @"";
    repsTF.text = set.reps ? [NSString stringWithFormat:@"%lu", set.reps] : @"";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview.superview;
   NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
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

@end
