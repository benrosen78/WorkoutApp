//
//  DBWWorkoutCalendarViewController.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutCalendarViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWExerciseTableViewController.h"
#import "DBWWorkoutTableViewController.h"
#import "DBWWorkoutManager.h"

@interface DBWWorkoutCalendarViewController ()

@property (nonatomic, readwrite) NSInteger firstDayOfMonthWeekday, monthLength;

@property (strong, nonatomic) NSArray <NSDate *> *selectedMonthDates;

@property (strong, nonatomic) NSArray <NSString *> *months;

@property (nonatomic) NSInteger selectedMonthIndex;

@end

@implementation DBWWorkoutCalendarViewController

static NSString *const reuseIdentifier = @"calendar-cell";
static NSString *const headerIdentifier = @"header-cell";

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;

    self = [self initWithCollectionViewLayout:layout];
    if (self) {
        _months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date]];
    [self switchMonthToIndex:components.month - 1];
    self.title = [NSString stringWithFormat:@"%@'s Gains", _months[_selectedMonthIndex]];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(switchMonth:)];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchMonth:(UIBarButtonItem *)item {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"You there!" message:@"Select the month you would like to view." preferredStyle:UIAlertControllerStyleActionSheet];
    controller.popoverPresentationController.barButtonItem = item;
    for (NSString *month in _months) {
        NSString *monthString = [month stringByAppendingString:@"'s Gains"];
        [controller addAction:[UIAlertAction actionWithTitle:monthString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self switchMonthToIndex:[_months indexOfObject:month]];
            self.title = monthString;
        }]];
    }
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)switchMonthToIndex:(NSInteger)index {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    components.month = index + 1;
    components.year = 2017;
    
    // convert it into an NSDate and then break it back into components again for the weekday
    NSDate *firstOfMonthDate = [gregorian dateFromComponents:components];
    NSDateComponents *newComponents = [gregorian components:NSCalendarUnitWeekday fromDate:firstOfMonthDate];
    
    _firstDayOfMonthWeekday = [newComponents weekday];
    
    _monthLength = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstOfMonthDate].length;
    
    _selectedMonthIndex = components.month - 1;
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _monthLength + _firstDayOfMonthWeekday - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    UIView *colorView = [cell viewWithTag:124] ?: [[UIView alloc] init];
    colorView.tag = 124;
    colorView.layer.masksToBounds = YES;
    colorView.layer.cornerRadius = 30;
    colorView.backgroundColor = [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00];
    colorView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:colorView];
    
    UILabel *day = [cell viewWithTag:123] ?: [[UILabel alloc] init];
    day.tag = 123;
    day.text = indexPath.row < _firstDayOfMonthWeekday - 1 ? @"" : [NSString stringWithFormat:@"%lu", indexPath.row + 2 - _firstDayOfMonthWeekday];
    day.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    day.textAlignment = NSTextAlignmentCenter;
    day.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:day];
    [cell.contentView addCompactConstraints:@[@"day.centerX = view.centerX",
                                              @"day.centerY = view.centerY",
                                              @"color.centerX = view.centerX",
                                              @"color.centerY = view.centerY",
                                              @"color.width = 60",
                                              @"color.height = 60"]
                                    metrics:nil
                                      views:@{@"day": day,
                                              @"color": colorView,
                                              @"view": cell.contentView
                                              }];
    NSInteger dayNumber = indexPath.row + 2 - _firstDayOfMonthWeekday;
    if ([DBWWorkoutManager workoutForDay:dayNumber month:_selectedMonthIndex + 1 year:2017]) {
        colorView.alpha = 1;
        day.textColor = [UIColor whiteColor];
    } else {
        colorView.alpha = 0;
        day.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];

        NSArray *days = @[@"S", @"M", @"T", @"W", @"TH", @"F", @"S"];
        for (int i = 0; i < 7; i++) {
            UIView *containerView = [[UIView alloc] init];
            containerView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:containerView];
            
            CGFloat cellWidth = self.view.frame.size.width / 7.0;
            CGFloat leftPosition = cellWidth * i;
            
            [view addCompactConstraints:@[@"containerView.height = view.height",
                                          @"containerView.width = cellWidth",
                                          @"containerView.left = view.left + leftPosition"]
                                metrics:@{@"cellWidth": @(cellWidth),
                                          @"leftPosition": @(leftPosition)
                                          }
                                  views:@{@"containerView": containerView,
                                          @"view": view
                                          }];
            
            UILabel *day = [[UILabel alloc] init];
            day.textAlignment = NSTextAlignmentCenter;
            day.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
            day.text = days[i];
            day.translatesAutoresizingMaskIntoConstraints = NO;
            [containerView addSubview:day];
            
            [containerView addCompactConstraints:@[@"day.centerX = view.centerX",
                                                   @"day.centerY = view.centerY"]
                                         metrics:nil
                                           views:@{@"day": day,
                                                   @"view": containerView
                                                   }];
        }
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [UIColor darkGrayColor];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:separator];
        
        [view addCompactConstraints:@[@"separator.top = view.bottom - 0.5",
                                      @"separator.height = 0.5",
                                      @"separator.left = view.left",
                                      @"separator.right = view.right"]
                            metrics:nil
                              views:@{@"separator": separator,
                                      @"view": view
                                      }];
        
        return view;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(floor(self.view.frame.size.width / 7), (self.collectionView.frame.size.height - 150) / 6);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger day = indexPath.row + 2 - _firstDayOfMonthWeekday;
    DBWWorkout *workout = [DBWWorkoutManager workoutForDay:day month:_selectedMonthIndex + 1 year:2017];
    if (!workout) {
        return;
    }
    
    DBWWorkoutTableViewController *vc = [[DBWWorkoutTableViewController alloc] initWithWorkout:workout];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
