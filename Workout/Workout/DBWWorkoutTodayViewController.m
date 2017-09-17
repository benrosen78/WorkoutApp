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
#import "DBWExerciseCollectionViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWWorkoutTemplate.h"
#import "DBWDatabaseManager.h"
#import "DBWCustomizeWorkoutPlanCollectionHeaderView.h"
#import "DBWWorkoutPlanDayCell.h"
#import "DBWWorkoutTodayExercisesViewController.h"
#import "DBWWorkoutTemplateList.h"
#import "UIColor+ColorPalette.h"
#import "AppDelegate.h"

@interface DBWWorkoutTodayViewController ()

@end

@implementation DBWWorkoutTodayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _workout = [[DBWDatabaseManager sharedDatabaseManager] todaysWorkout];
    if (!_workout) {
        return;
    }

    DBWWorkoutTodayExercisesViewController *exercisesViewController = [[DBWWorkoutTodayExercisesViewController alloc] initWithWorkout:_workout];
    exercisesViewController.headerCell.alpha = 1;
    
    self.navigationController.viewControllers = @[exercisesViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Today's Gains";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    // create a snapshot and set up a shadow
    UIView *headerView = [cell snapshotViewAfterScreenUpdates:NO];
    headerView.layer.shadowRadius = 10;
    headerView.layer.shadowOffset = CGSizeMake(0, 0);
    headerView.layer.shadowOpacity = 0.0;
    headerView.frame = [self.view convertRect:cell.frame fromView:self.collectionView];
    [self.view addSubview:headerView];

    // make it appear above all other things with a transform and shadow
    [UIView animateWithDuration:0.3 animations:^{
        headerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.03, 1.03);
        headerView.layer.shadowOpacity = 0.18;
    }];
    
    // move it to top position for the next view
    [UIView animateWithDuration:0.55 delay:0.15 usingSpringWithDamping:0.95 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        headerView.frame = CGRectMake(headerView.frame.origin.x, 135, headerView.frame.size.width, headerView.frame.size.height);
    } completion:nil];
    
    // animate the collection view away
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.collectionView.frame = CGRectMake(0, self.collectionView.frame.size.height, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
        self.collectionView.alpha = 0;
    } completion:nil];
    
    // make the exercise view with no alpha and put it out of the view so we can animate these proporties
    DBWWorkout *workout = [DBWWorkout todaysWorkoutWithTemplate:self.templateList.list[indexPath.row]];
    [[DBWDatabaseManager sharedDatabaseManager] saveNewWorkout:workout];
    DBWWorkoutTodayExercisesViewController *exercisesViewController = [[DBWWorkoutTodayExercisesViewController alloc] initWithWorkout:workout];
    exercisesViewController.headerCell.alpha = 0;
    exercisesViewController.view.backgroundColor = [UIColor clearColor];
    exercisesViewController.collectionView.backgroundColor = [UIColor clearColor];
    exercisesViewController.collectionView.alpha = 0;
    exercisesViewController.collectionView.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    // get rid of the shadow and transform. make it looked like its placed. then replace it with the same exact header in the new view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            headerView.layer.shadowOpacity = 0;
            headerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [headerView removeFromSuperview];
            exercisesViewController.headerCell.alpha = 1;
        }];
    });
    
    // then add the new view. add it as a child view controller so the old view is behind it. then later we actually push it. animate the collection view frame back into view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addChildViewController:exercisesViewController];
        [self.view addSubview:exercisesViewController.view];
        [exercisesViewController didMoveToParentViewController:self];

        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            exercisesViewController.collectionView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        } completion:nil];
    });
    
    // animate the alpha of the new view to 1 and then actually push the view. change the bg color back to the color we want because the old one would not allow to have animations in both views at the same time.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            exercisesViewController.collectionView.alpha = 1;
        } completion:^(BOOL finished) {
            exercisesViewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [exercisesViewController willMoveToParentViewController:nil];
            self.navigationController.viewControllers = @[exercisesViewController];
        }];
    });
}
#pragma mark - Table view data source
/*
- (NSInteger)coll {
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
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


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
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    DBWCustomizeWorkoutPlanCollectionHeaderView *headerView = (DBWCustomizeWorkoutPlanCollectionHeaderView *)[super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    headerView.instructionsText = @"You haven't worked out yet today!\n\nIf you're ready to work out, select a template from below. This will customize your log for the day by automatically filling it with the exercises you have assigned to the template you select.\n\nHave a good lift! 😀🏋️‍♀️";
    return headerView;
    
}

@end
