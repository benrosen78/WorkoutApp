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
#import "DBWDatabaseManager.h"
#import "DBWColorTableViewCell.h"
#import "UIColor+ColorPalette.h"
#import "DBWExerciseDatabaseTableViewController.h"
#import "DBWExercisePlaceholder.h"

static NSString *const kColorCellIdentifier = @"color-cell";
static NSString *const kShortDescCellIdentifier = @"desc-cell";
static NSString *const kExerciseCellIdentifier = @"exercise-cell";
static NSString *const kDeleteCellIdentifier = @"delete-cell";

@interface DBWTemplateCustomizationTableViewController () <UITextViewDelegate, DBWExerciseDatabaseDelegate>

@property (strong, nonatomic) DBWWorkoutTemplate *template;

@property (strong, nonatomic) NSArray <NSString *> *colorNames;

@property (strong, nonatomic) NSIndexPath *selectedColorIndexPath;

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
    
    _colorNames = @[@"Red", @"Orange", @"Yellow", @"Green", @"Teal Blue", @"Blue", @"Purple", @"Pink"];

    self.title = [NSString stringWithFormat:@"Day: %lu", [[DBWDatabaseManager sharedDatabaseManager].templateList.list indexOfObject:_template] + 1];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    _selectedColorIndexPath = [NSIndexPath indexPathForRow:_template.selectedColorIndex inSection:0];

    
    [self.tableView registerClass:[DBWColorTableViewCell class] forCellReuseIdentifier:kColorCellIdentifier];
    
    self.editing = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    } else if (section == 1 || section == 3) {
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
    return indexPath.section == 1 ? 70 : 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DBWColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kColorCellIdentifier forIndexPath:indexPath];
        cell.color = [UIColor calendarColors][indexPath.row];
        cell.textLabel.text = _colorNames[indexPath.row];
        cell.accessoryType = [indexPath isEqual:_selectedColorIndexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShortDescCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShortDescCellIdentifier];
            
            UITextView *textView = [[UITextView alloc] init];
            textView.delegate = self;
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
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExerciseCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kExerciseCellIdentifier];
        }
        
        if ((indexPath.row >= [_template.exercises count] && [self isEditing]) || (_template.exercises.count == 0)) {
            cell.textLabel.text = @"Add Excercise";
        } else {
            DBWExercise *exercise = _template.exercises[indexPath.row];
            cell.textLabel.text = exercise.placeholder.name;
        }
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDeleteCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDeleteCellIdentifier];
        }
        cell.textLabel.text = @"Delete";
        cell.textLabel.textColor = [UIColor redColor];
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Color";
    } else if (section == 1) {
        return @"Short Description";
    } else if (section == 2) {
        return @"Exercises";
    } else if (section == 3) {
        return @"Delete";
    }
    return nil;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
        [_template.exercises removeObjectAtIndex:indexPath.row];
        [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
        
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect rect = [self.tableView convertRect:selectedCell.textLabel.bounds toView:self.view];
        
        DBWExerciseDatabaseTableViewController *exerciseDBViewController = [[DBWExerciseDatabaseTableViewController alloc] init];
        exerciseDBViewController.delegate = self;
        
        UINavigationController *newNavigationController = [[UINavigationController alloc] initWithRootViewController:exerciseDBViewController];
        newNavigationController.modalPresentationStyle = UIModalPresentationPopover;
        newNavigationController.popoverPresentationController.sourceView = selectedCell;
        newNavigationController.popoverPresentationController.sourceRect = rect;
        newNavigationController.preferredContentSize = CGSizeMake(400, 500);
        
        [self presentViewController:newNavigationController animated:YES completion:nil];
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.editing || indexPath.section != 2) {
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
    return indexPath.section == 2;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [tableView cellForRowAtIndexPath:_selectedColorIndexPath].accessoryType = UITableViewCellAccessoryNone;
        _selectedColorIndexPath = indexPath;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

        [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
        _template.selectedColorIndex = _selectedColorIndexPath.row;
        [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
    } else if (indexPath.section == 3) {
        UIAlertController *deleteController = [UIAlertController alertControllerWithTitle:@"Workout App" message:@"Are you sure you want to delete this workout template? You can't recover it." preferredStyle:UIAlertControllerStyleAlert];
        [deleteController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [deleteController addAction:[UIAlertAction actionWithTitle:@"I'm sure" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[DBWDatabaseManager sharedDatabaseManager] deleteWorkoutTemplate:_template];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:deleteController animated:YES completion:nil];
    } else if (indexPath.row == [_template.exercises count] && indexPath.section == 2) {
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    _template.shortDescription = textView.text;
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 2 && indexPath.row < [_template.exercises count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toProposedIndexPath:(nonnull NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == [_template.exercises count]) {
        return [NSIndexPath indexPathForRow:[_template.exercises count] - 1 inSection:2];
    } else if (proposedDestinationIndexPath.section == 0 || proposedDestinationIndexPath.section) {
        return [NSIndexPath indexPathForRow:0 inSection:2];
    } else if (proposedDestinationIndexPath.section == 2) {
        return [NSIndexPath indexPathForRow:[_template.exercises count] - 1 inSection:2];
    }
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    [_template.exercises moveObjectAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
}

#pragma mark - DBWExerciseDatabaseDelegate

- (void)finishedWithExercise:(DBWExercise *)exercise {
    [[DBWDatabaseManager sharedDatabaseManager] startTemplateWriting];
    [_template.exercises addObject:exercise];
    [[DBWDatabaseManager sharedDatabaseManager] endTemplateWriting];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
