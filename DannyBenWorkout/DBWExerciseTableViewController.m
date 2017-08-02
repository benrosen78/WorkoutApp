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
#import "DBWWorkoutManager.h"


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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)add:(UIBarButtonItem *)item {
    [_exercise.sets addObject:[DBWSet new]];
    [DBWWorkoutManager saveWorkout:_exercise.workout];
    
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [[UITextField alloc] init];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.textColor = [UIColor blackColor];
        textField.delegate = self;
        
        textField.placeholder = @"Required";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyDone;
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        textField.textAlignment = NSTextAlignmentLeft;
        textField.tag = 1;
        
        textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [textField setEnabled: YES];
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:textField];
        
        [cell.contentView addCompactConstraints:@[@"text.right = view.right - 10",
                                                  @"text.width = 200",
                                                  @"text.top = view.top + 5",
                                                  @"text.bottom = view.bottom - 5"]
                                        metrics:nil
                                          views:@{@"text": textField,
                                                  @"view": cell.contentView
                                                  }];

    }
    cell.textLabel.text = indexPath.row == 0 ? @"Weight" : @"Reps";
    
    UITextField *field = [cell viewWithTag:1];
    
    field.placeholder = indexPath.row == 0 ? @"Weight" : @"Reps";
    
    DBWSet *set = _exercise.sets[indexPath.section];
    if (indexPath.row == 0) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 20;
        
        field.text = set.weight ? [NSString stringWithFormat:@"%@", [formatter stringFromNumber:@(set.weight)]] : @"";
        field.placeholder = @"Weight";
    } else if (indexPath.row == 1) {
        field.text = set.reps ? [NSString stringWithFormat:@"%lu", set.reps] : @"";
        field.placeholder = @"Reps";
    }
    
    cell.accessoryView = [[UITextField alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    DBWSet *set = _exercise.sets[path.section];
    if (path.row == 0) {
        set.weight = [textField.text floatValue];
    } else if (path.row == 1) {
        set.reps = [textField.text integerValue];
    }
    [DBWWorkoutManager saveWorkout:_exercise.workout];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
