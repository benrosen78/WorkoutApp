//
//  DBWWorkoutCalendarViewController.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWWorkoutCalendarViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWExerciseCollectionViewController.h"
#import "DBWWorkoutTableViewController.h"
#import "DBWDatabaseManager.h"
#import "DBWCalendarCollectionViewCell.h"
#import "DBWWorkout.h"
#import "DBWWorkoutTemplate.h"
#import "DBWCalendarDatePickerViewController.h"
#import "UIColor+ColorPalette.h"

@interface DBWWorkoutCalendarViewController () <DBWDatePickerDelegate, UIPopoverPresentationControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, readwrite) NSInteger firstDayOfMonthWeekday, monthLength;

@property (strong, nonatomic) NSArray <NSString *> *months;

@property (nonatomic) NSInteger year;

@property (nonatomic) NSInteger selectedMonthIndex;

@end

@implementation DBWWorkoutCalendarViewController

static NSString *const reuseIdentifier = @"calendar-cell";
static NSString *const headerIdentifier = @"header-cell";

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 1;
    
    CGFloat sideInset = ([UIScreen mainScreen].bounds.size.width -  ((ceil([UIScreen mainScreen].bounds.size.width / 7)) * 7)) / 2.0;
    sideInset -= 3;
    layout.sectionInset = UIEdgeInsetsMake(0, sideInset, 0, sideInset);
    
    self = [self initWithCollectionViewLayout:layout];
    if (self) {
        _months = [[[NSDateFormatter alloc] init] monthSymbols];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Calendar";
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    [self monthSelected:components.month - 1 year:components.year];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.902 green:0.898 blue:0.902 alpha:1.00];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(switchMonth:)];

    [self.collectionView registerClass:[DBWCalendarCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
    /*
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"You there!" message:@"Select the month you would like to view." preferredStyle:UIAlertControllerStyleActionSheet];
    controller.popoverPresentationController.barButtonItem = item;
    for (NSString *month in _months) {
        NSString *monthString = [month stringByAppendingString:@"'s Gains"];
        [controller addAction:[UIAlertAction actionWithTitle:monthString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self switchMonthToIndex:[_months indexOfObject:month]];
            self.title = monthString;
        }]];
    }
    [self presentViewController:controller animated:YES completion:nil];*/
    DBWCalendarDatePickerViewController *picker = [[DBWCalendarDatePickerViewController alloc] initWithCurrentMonth:_selectedMonthIndex andYear:_year];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationPopover;
    picker.popoverPresentationController.delegate = self;
    picker.preferredContentSize = CGSizeMake(350, 260);
    picker.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - DBWDatePickerDelegate

- (void)monthSelected:(NSInteger)month year:(NSInteger)year {
    _selectedMonthIndex = month;
    _year = year;
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    components.month = month + 1;
    components.year = year;
    
    // convert it into an NSDate and then break it back into components again for the weekday
    NSDate *firstOfMonthDate = [gregorian dateFromComponents:components];
    NSDateComponents *newComponents = [gregorian components:NSCalendarUnitWeekday fromDate:firstOfMonthDate];
    
    _firstDayOfMonthWeekday = [newComponents weekday];
    
    _monthLength = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstOfMonthDate].length;
    
    [self.collectionView reloadData];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %lu", _months[_selectedMonthIndex], _year];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _monthLength + _firstDayOfMonthWeekday - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DBWCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //cell.layer.borderWidth = 0.5;
    
    cell.backgroundColor = [UIColor whiteColor];


    
    NSInteger dayNumber = indexPath.row + 2 - _firstDayOfMonthWeekday;
    cell.dayLabel.text = indexPath.row < _firstDayOfMonthWeekday - 1 ? @"" : [NSString stringWithFormat:@"%lu", dayNumber];

    NSDateComponents *todaysComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    if (todaysComponents.day == dayNumber && todaysComponents.month == _selectedMonthIndex + 1 && todaysComponents.year == _year) {
        cell.colorView.alpha = 1;
        cell.dayLabel.textColor = [UIColor whiteColor];
    } else {
        cell.colorView.alpha = 0;
        cell.dayLabel.textColor = [UIColor blackColor];

    }
    
    DBWWorkout *workout = [[DBWDatabaseManager sharedDatabaseManager] workoutForDay:dayNumber month:_selectedMonthIndex + 1 year:_year];
    if (workout) {
        cell.workoutLabel.alpha = 1;
        cell.workoutLabel.text = [NSString stringWithFormat:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"Day %lu" : @"%lu", workout.templateDay];
        cell.workoutLabel.backgroundColor = [UIColor calendarColors][workout.selectedColorIndex];
    } else {
        cell.workoutLabel.alpha = 0;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        
        NSArray *days = @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"];
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
            day.textAlignment = NSTextAlignmentRight;
            day.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
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
        separator.alpha = 1;
        separator.backgroundColor = [UIColor colorWithRed:0.902 green:0.898 blue:0.902 alpha:1.00];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:separator];
        
        [view addCompactConstraints:@[@"separator.bottom = view.bottom",
                                      @"separator.height = 1",
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 60);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger day = indexPath.row + 2 - _firstDayOfMonthWeekday;
    
    DBWWorkout *workout = [[DBWDatabaseManager sharedDatabaseManager] workoutForDay:day month:_selectedMonthIndex + 1 year:_year];
    if (!workout) {
        return;
    }

    DBWWorkoutTableViewController *vc = [[DBWWorkoutTableViewController alloc] initWithWorkout:workout];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ceil([UIScreen mainScreen].bounds.size.width / 7), (self.collectionView.frame.size.height - 60 - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - 26) / 6);
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
