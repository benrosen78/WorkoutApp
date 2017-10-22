//
//  DBWStopwatchActiveViewController.m
//  Workout
//
//  Created by Ben Rosen on 10/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatchActiveViewController.h"
#import "UIColor+ColorPalette.h"

@interface DBWStopwatchActiveViewController ()

@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation DBWStopwatchActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:100 weight:UIFontWeightLight];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.text = @"1:59";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_timeLabel];
    
    [_timeLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_timeLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [_timeLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:80].active = YES;

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
