//
//  DBWCalendarDatePickerViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWCalendarDatePickerViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWDatabaseManager.h"

@interface DBWCalendarDatePickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *datePicker;

@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) NSArray <NSString *> *months;

@property (strong, nonatomic) NSArray <NSNumber *> *years;

@property (nonatomic) NSInteger month, year;

@end

@implementation DBWCalendarDatePickerViewController

- (instancetype)initWithCurrentMonth:(NSInteger)month andYear:(NSInteger)year {
    self = [super init];
    if (self) {
        _month = month;
        _year = year;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _months = [[[NSDateFormatter alloc] init] monthSymbols];
    _years = [[DBWDatabaseManager sharedDatabaseManager] yearsInDatabase];
    
    _datePicker = [[UIPickerView alloc] init];
    _datePicker.delegate = self;
    _datePicker.dataSource = self;
    _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_datePicker];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _okButton.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [_okButton setTitle:@"OK" forState:UIControlStateNormal];
    [_okButton addTarget:self action:@selector(okTapped:) forControlEvents:UIControlEventTouchUpInside];
    _okButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _okButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    _okButton.tintColor = [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00];
    _okButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_okButton];
    
    [self.view addCompactConstraints:@[@"date.left = view.left",
                                       @"date.right = view.right",
                                       @"date.top = view.top",
                                       @"ok.top = date.bottom + 2",
                                       @"ok.left = view.left",
                                       @"ok.right = view.right"]
                             metrics:nil
                               views:@{@"date": _datePicker,
                                       @"ok": _okButton,
                                       @"view": self.view
                                       }];
    
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    [_datePicker selectRow:_month inComponent:0 animated:NO];
    [_datePicker selectRow:[_years indexOfObject:@(_year)] inComponent:1 animated:NO];
}

- (void)okTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate monthSelected:[_datePicker selectedRowInComponent:0] year:_years[[_datePicker selectedRowInComponent:1]].integerValue];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? [_months count] : [_years count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return component == 0 ? _months[row] : _years[row].stringValue;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return component == 0 ? 185 : 115;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
