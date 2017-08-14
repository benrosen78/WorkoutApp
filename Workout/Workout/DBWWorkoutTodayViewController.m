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
#import <CompactConstraint/CompactConstraint.h>
#import "DBWWorkoutTemplate.h"
#import "DBWDatabaseManager.h"

@interface DBWWorkoutTodayViewController ()

@end

@implementation DBWWorkoutTodayViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _workout = [[DBWDatabaseManager sharedDatabaseManager] todaysWorkout];
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
        DBWExercise *exercise = _workout.exercises[indexPath.row];
        cell.textLabel.text = exercise.name;

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
        [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
        [_workout.exercises removeObjectAtIndex:indexPath.row];
        [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Hello" message:@"What would you like to title the exercise?" preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [controller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *text = controller.textFields[0].text;
                DBWExercise *exercise = [DBWExercise exerciseWithName:text baseNumberOfSets:3];

                [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
                [_workout.exercises addObject:exercise];
                [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
                
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
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Hey there!" message:@"You gotta go to the gym. Select which day you would like to use. This will be a template for you to log on." preferredStyle:UIAlertControllerStyleActionSheet];
        RLMArray <DBWWorkoutTemplate *> *templates = [[DBWDatabaseManager sharedDatabaseManager] templateList].list;
        for (int i = 0; i < [templates count]; i++) {
            DBWWorkoutTemplate *option = templates[i];
            [controller addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%d - %@", i + 1, option.shortDescription ?: @""] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _workout = [DBWWorkout todaysWorkoutWithTemplate:option];
                [[DBWDatabaseManager sharedDatabaseManager] saveNewWorkout:_workout];
                
                [self.tableView reloadData];
            }]];
        }
        [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        controller.popoverPresentationController.sourceView = [tableView cellForRowAtIndexPath:indexPath];
        controller.popoverPresentationController.sourceRect = controller.popoverPresentationController.sourceView.frame;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _workout ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 300;
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    [_workout.exercises moveObjectAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return indexPath.row < _workout.exercises.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toProposedIndexPath:(nonnull NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == [_workout.exercises count]) {
        return [NSIndexPath indexPathForRow:[_workout.exercises count] - 1 inSection:0];
    }
    return proposedDestinationIndexPath;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
