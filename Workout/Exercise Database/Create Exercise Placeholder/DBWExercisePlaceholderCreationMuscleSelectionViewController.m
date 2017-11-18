//
//  DBWExercisePlaceholderCreationMuscleSelectionViewController.m
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePlaceholderCreationMuscleSelectionViewController.h"

static NSString *const kMuscleSelectionReuseIdentifier = @"MuscleSelectionReuseIdentifier";

@interface DBWExercisePlaceholderCreationMuscleSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *musclesNames, *muscleImageNames;

@end

@implementation DBWExercisePlaceholderCreationMuscleSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _musclesNames = @[@"Chest", @"Back", @"Shoulders", @"Core", @"Arms", @"Legs"];
    _muscleImageNames = @[@"chest", @"back", @"shoulder", @"core", @"arm", @"legs"];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Choose a muscle group";
    title.font = [UIFont systemFontOfSize:26 weight:UIFontWeightSemibold];
    title.textAlignment = NSTextAlignmentCenter;
    title.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:title];
    
    [title.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:17].active = YES;
    [title.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    UITableView *muscleSelectionTableView = [[UITableView alloc] init];
    muscleSelectionTableView.scrollEnabled = NO;
    muscleSelectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    muscleSelectionTableView.delegate = self;
    muscleSelectionTableView.dataSource = self;
    muscleSelectionTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:muscleSelectionTableView];
    
    [muscleSelectionTableView.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:17].active = YES;
    [muscleSelectionTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:40].active = YES;
    [muscleSelectionTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-40].active = YES;
    [muscleSelectionTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10].active = YES;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMuscleSelectionReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMuscleSelectionReuseIdentifier];
    }
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 15;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    cell.textLabel.text = _musclesNames[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_muscleImageNames[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.completionDelegate selectedMuscleGroup:indexPath.row];
}

@end


