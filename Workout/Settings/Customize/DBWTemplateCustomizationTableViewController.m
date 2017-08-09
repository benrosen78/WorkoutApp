//
//  DBWTemplateCustomizationTableViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWTemplateCustomizationTableViewController.h"
#import "DBWWorkoutTemplate.h"
#import "DBWExercise.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWWorkoutManager.h"

static NSString *const kDayCellIdentifier = @"day-cell";
static NSString *const kShortDescCellIdentifier = @"desc-cell";
static NSString *const kExerciseCellIdentifier = @"exercise-cell";

@interface DBWTemplateCustomizationTableViewController ()

@property (strong, nonatomic) DBWWorkoutTemplate *template;

@end

@implementation DBWTemplateCustomizationTableViewController

- (instancetype)initWithTemplate:(DBWWorkoutTemplate *)workoutTemplate {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _template = workoutTemplate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"Day: %lu", _template.day];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (tableView.editing) {
            return [_template.exercises count] + 1;
        } else {
            return [_template.exercises count];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 110 : 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShortDescCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShortDescCellIdentifier];
            
            UITextView *textView = [[UITextView alloc] init];
            textView.text = _template.shortDescription ?: @"";
            textView.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
            textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            textView.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:textView];
            
            [cell.contentView addCompactConstraints:@[@"text.left = view.left+8",
                                                      @"text.right = view.right-8",
                                                      @"text.top = view.top+6",
                                                      @"text.bottom = view.bottom-6"]
                                            metrics:nil
                                              views:@{@"text": textView,
                                                      @"view": cell.contentView
                                                      }];
        }
        cell.shouldIndentWhileEditing = NO;
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExerciseCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kExerciseCellIdentifier];
        }
        
        if (indexPath.row >= [_template.exercises count] && [self isEditing]) {
            cell.textLabel.text = @"Add Excercise";
        } else {
            cell.textLabel.text = _template.exercises[indexPath.row].name;
        }
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Short Description";
    } else if (section == 1) {
        return @"Exercises";
    }
    return nil;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_template.exercises removeObjectAtIndex:indexPath.row];
        //[DBWWorkoutManager saveWorkout:_workout];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Hello" message:@"What would you like to title the exercise?" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [controller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *text = controller.textFields[0].text;
            DBWExercise *exercise = [DBWExercise exerciseWithName:text baseNumberOfSets:3];
            //exercise.workout = _workout;
            [_template.exercises addObject:exercise];
            
            //[DBWWorkoutManager saveWorkout:_workout];
            [self setEditing:NO animated:YES];
        }]];
        [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Partial squats";
        }];
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.editing || indexPath.section != 1) {
        return UITableViewCellEditingStyleNone;
    } else if (indexPath.row < [_template.exercises count]) {
        return UITableViewCellEditingStyleDelete;
    } else if (indexPath.row == [_template.exercises count]) {
        return UITableViewCellEditingStyleInsert;
    } else  {
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.isEditing && indexPath.row >= [_template.exercises count]) {
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
    }
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
