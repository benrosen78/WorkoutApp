//
//  DBWWorkoutTodayViewController.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutTodayViewController.h"
#import "DBWWorkout.h"
#import "DBWExercise.h"
#import "DBWExerciseTableViewController.h"
#import "DBWWorkoutManager.h"
#import <CompactConstraint/CompactConstraint.h>

@interface DBWWorkoutTodayViewController ()

@end

@implementation DBWWorkoutTodayViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _workout = [DBWWorkoutManager workoutForDay:[NSDate date]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Today's Gains";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_workout) {
        return 1;
    } else {
        return tableView.editing ? [_workout.exercises count] + 1 : [_workout.exercises count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_workout) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseCell"];
            UILabel *choose = [[UILabel alloc] init];
            choose.numberOfLines = 0;
            choose.textAlignment = NSTextAlignmentCenter;
            choose.font = [UIFont systemFontOfSize:24 weight:UIFontWeightRegular];
            choose.text = @"You haven't worked out yet! Tap to choose what day you're doing today.";
            choose.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:choose];
            
            [cell.contentView addCompactConstraints:@[@"choose.left = view.left + constant",
                                                      @"choose.right = view.right - constant",
                                                      @"choose.centerY = view.centerY"]
                                            metrics:@{@"constant": @(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 200 : 25)}
                                              views:@{@"choose": choose,
                                                      @"view": cell.contentView
                                                      }];
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row >= [_workout.exercises count] && [self isEditing]) {
        cell.textLabel.text = @"Add Excercise";
    } else {
        cell.textLabel.text = _workout.exercises[indexPath.row].name;

    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_workout.exercises removeObjectAtIndex:indexPath.row];
        [DBWWorkoutManager saveWorkout:_workout];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Hello" message:@"What would you like to title the exercise?" preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [controller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *text = controller.textFields[0].text;
                DBWExercise *exercise = [DBWExercise exerciseWithName:text];
                exercise.workout = _workout;
                [_workout.exercises addObject:exercise];
                
                [DBWWorkoutManager saveWorkout:_workout];
                [self setEditing:NO animated:YES];
            }]];
            [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"Partial squats";
            }];
            [self presentViewController:controller animated:YES completion:nil];

    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   // return UITableViewCellEditingStyleInsert;
    if (!self.tableView.editing) {
        return UITableViewCellEditingStyleNone;
    } else if (indexPath.row < [_workout.exercises count]) {
        return UITableViewCellEditingStyleDelete;
    } else if (indexPath.row == [_workout.exercises count]) {
        return UITableViewCellEditingStyleInsert;
    } else  {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_workout) {
        if (tableView.isEditing && indexPath.row >= [_workout.exercises count]) {
            [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
        }
        if (!tableView.isEditing) {
            DBWExerciseTableViewController *vc = [[DBWExerciseTableViewController alloc] initWithExercise:_workout.exercises[indexPath.row]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        NSArray <NSString *> *options = @[@"Pull day 1 (w/ abs)", @"Push day 1", @"Legs day 1 (w/ abs)", @"Pull day 2", @"Push day 2 (w/ abs)", @"Leg day 2 (w/ pullups)"];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Hey there!" message:@"You gotta go to the gym. Select which day you would like to use. This will be a template for you to log on." preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0; i < [options count]; i++) {
            NSString *option = options[i];
            [controller addAction:[UIAlertAction actionWithTitle:option style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _workout = [DBWWorkout workoutWithDate:[NSDate date] andTemplate:i];
                [self.tableView reloadData];
                [DBWWorkoutManager saveWorkout:_workout];
            }]];
        }
        controller.popoverPresentationController.sourceView = [tableView cellForRowAtIndexPath:indexPath];
        controller.popoverPresentationController.sourceRect = controller.popoverPresentationController.sourceView.frame;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _workout ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 300;
}

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
