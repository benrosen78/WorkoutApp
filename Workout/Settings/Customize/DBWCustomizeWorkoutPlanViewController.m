//
//  DBWCustomizeWorkoutPlanViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/9/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWCustomizeWorkoutPlanViewController.h"
#import "DBWWorkoutPlanDayCell.h"
#import "DBWWorkoutTemplate.h"
#import "DBWTemplateCustomizationTableViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWDatabaseManager.h"
#import "DBWWorkoutTemplateList.h"
#import "DBWCustomizeWorkoutPlanCollectionHeaderView.h"
#import "UIColor+ColorPalette.h"

static NSString *const cellIdentifier = @"day-identifier";
static NSString *const headerIdentifier = @"header-identifier";

@interface DBWCustomizeWorkoutPlanViewController ()

@end

@implementation DBWCustomizeWorkoutPlanViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 25, 25, 25);
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
    return CGSizeMake(self.view.frame.size.width - 25, 105);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBWWorkoutTemplate *template = _templateList.list[indexPath.row];
    
    DBWWorkoutPlanDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = [NSString stringWithFormat:@"Day %lu", indexPath.row + 1];
    cell.detailLabel.text = template.shortDescription ?: @"Tap to configure!";
    cell.color = [UIColor calendarColors][template.selectedColorIndex];
    
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
        view.instructionsText = @"Templates represent a \"day\" in the gym. You fill a template with exercises. When you workout, you can select a template and the exercises will fill in.\n\n Tap '+' to create a new template.\nPress and hold on a day to reposition it.";
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, [_templateList.list count] > 0 ? 120 : self.collectionView.frame.size.height - 200);
}

@end
