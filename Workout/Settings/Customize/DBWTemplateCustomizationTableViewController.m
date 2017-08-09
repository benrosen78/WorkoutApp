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

static NSString *const kInfoCellIdentifier = @"info-cell";
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
    return section == 0 ? 2 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kInfoCellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = indexPath.row == 0 ? @"Day:" : @"Short Description:";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Exercise";
    }
    // Configure the cell...
    
    return cell;
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
