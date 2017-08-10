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

static NSString *const cellIdentifier = @"day-identifier";

@interface DBWCustomizeWorkoutPlanViewController ()

@property (strong, nonatomic) NSMutableArray <DBWWorkoutTemplate *> *templates;

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
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[DBWWorkoutPlanDayCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    _templates = [DBWWorkoutManager templates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _templates = [DBWWorkoutManager templates];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_templates count];
}

- (CGSize)collectionView:(UICollectionViewCell *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width / 2.0, self.view.frame.size.width / 2.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBWWorkoutTemplate *template = _templates[indexPath.row];
    
    DBWWorkoutPlanDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"Day %lu", template.day];
    cell.detailLabel.text = template.shortDescription;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    DBWTemplateCustomizationTableViewController *customizationVC = [[DBWTemplateCustomizationTableViewController alloc] initWithTemplate:_templates[indexPath.row]];
    [self.navigationController pushViewController:customizationVC animated:YES];
}

@end
