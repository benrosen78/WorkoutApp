//
//  DBWExerciseDatabaseTableViewController.m
//  Workout
//
//  Created by Ben Rosen on 9/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseDatabaseTableViewController.h"
#import "DBWDatabaseManager.h"
#import "DBWExercisePlaceholder.h"
#import "DBWExerciseDatabase.h"
#import "DBWExerciseDatabaseConfirmationViewController.h"

static NSString *const kCellIdentifier = @"exercise-placeholder-cell";

@interface DBWExerciseDatabaseTableViewController ()

@property (strong, nonatomic) DBWExerciseDatabase *exerciseDatabasePlaceholders;

@end

@implementation DBWExerciseDatabaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _exerciseDatabasePlaceholders = [[DBWDatabaseManager sharedDatabaseManager] allExercisePlaceholders];
    
    self.title = @"Exercise Database";
    
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExercise:)];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)addExercise:(UIBarButtonItem *)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Exercise Database" message:@"What is the title of this exercise? If the exercise is already in the database, click Cancel and select it from the database." preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = controller.textFields[0].text;
        
        DBWExercisePlaceholder *exercisePlaceholder = [[DBWExercisePlaceholder alloc] init];
        exercisePlaceholder.name = text;
        [[DBWDatabaseManager sharedDatabaseManager] saveNewExercisePlaceholder:exercisePlaceholder];
        
        [self.tableView reloadData];
    }]];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Partial squats";
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_exerciseDatabasePlaceholders.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    DBWExercisePlaceholder *placeholder = _exerciseDatabasePlaceholders.list[indexPath.row];
    cell.textLabel.text = placeholder.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBWExercisePlaceholder *placeholder = _exerciseDatabasePlaceholders.list[indexPath.row];
    
    DBWExerciseDatabaseConfirmationViewController *confirmationViewController = [[DBWExerciseDatabaseConfirmationViewController alloc] init];
    confirmationViewController.title = placeholder.name;
    [self.navigationController pushViewController:confirmationViewController animated:YES];
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
