//
//  DBWCustomizeWorkoutPlanViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWCustomizeWorkoutPlanViewController.h"
#import "DBWWorkoutPlanDayCell.h"
#import "DBWWorkoutManager.h"
#import "DBWWorkoutTemplate.h"
#import "DBWTemplateCustomizationTableViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWDatabaseManager.h"
#import "DBWWorkoutTemplateList.h"
#import "DBWCustomizeWorkoutPlanCollectionHeaderView.h"

static NSString *const cellIdentifier = @"day-identifier";
static NSString *const headerIdentifier = @"header-identifier";

@interface DBWCustomizeWorkoutPlanViewController ()

@property (strong, nonatomic) DBWWorkoutTemplateList *templateList;

@end

@implementation DBWCustomizeWorkoutPlanViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Templates";
    
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.collectionView registerClass:[DBWWorkoutPlanDayCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[DBWCustomizeWorkoutPlanCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
    
    _templateList = [[DBWDatabaseManager sharedDatabaseManager] templateList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTapped:(UIBarButtonItem *)sender {
    DBWWorkoutTemplate *newTemplate = [[DBWWorkoutTemplate alloc] init];
    [[DBWDatabaseManager sharedDatabaseManager] saveNewWorkoutTemplate:newTemplate];
    [self.collectionView reloadData];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_templateList.list count];
}

- (CGSize)collectionView:(UICollectionViewCell *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width / 2.0, 135);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBWWorkoutTemplate *template = _templateList.list[indexPath.row];
    
    DBWWorkoutPlanDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.titleLabel.text = [NSString stringWithFormat:@"Day %lu", indexPath.row + 1];
    cell.detailLabel.text = template.shortDescription ?: @"Tap to configure!";
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    DBWTemplateCustomizationTableViewController *customizationVC = [[DBWTemplateCustomizationTableViewController alloc] initWithTemplate:_templateList.list[indexPath.row]];
    [self.navigationController pushViewController:customizationVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    DBWWorkoutTemplate *source = _templateList.list[sourceIndexPath.row];
    [[DBWDatabaseManager sharedDatabaseManager] moveWorkoutTemplate:source toIndex:destinationIndexPath.row];
    [collectionView reloadItemsAtIndexPaths:collectionView.indexPathsForVisibleItems];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DBWCustomizeWorkoutPlanCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 140);
}

@end
