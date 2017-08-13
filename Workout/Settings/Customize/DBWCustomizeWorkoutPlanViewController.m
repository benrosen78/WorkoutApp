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
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
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
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *instructionsLabel = [[UILabel alloc] init];
        instructionsLabel.text = @"Templates contain a list of exercises. You can choose a template when you workout and the exercises will autofill in.\n\n Tap '+' to create a new template.\nPress and hold on a day to reposition it.";
        instructionsLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        instructionsLabel.textColor = [UIColor grayColor];
        instructionsLabel.numberOfLines = 0;
        instructionsLabel.textAlignment = NSTextAlignmentCenter;
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:instructionsLabel];
        
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [UIColor darkGrayColor];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:separator];
        
        [view addCompactConstraints:@[@"separator.top = view.bottom - 0.5",
                                      @"separator.height = 0.5",
                                      @"separator.left = view.left",
                                      @"separator.right = view.right",
                                      @"instructions.top = view.top + 5",
                                      @"instructions.left = view.left + 5",
                                      @"instructions.right = view.right - 5",
                                      @"instructions.bottom = view.bottom - 5"]
                            metrics:nil
                              views:@{@"separator": separator,
                                      @"instructions": instructionsLabel,
                                      @"view": view
                                      }];
        
        return view;
    }
    
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 140);
}

@end
