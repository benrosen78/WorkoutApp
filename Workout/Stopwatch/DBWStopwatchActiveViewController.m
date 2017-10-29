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

@property (strong, nonatomic) UIButton *cancelButton, *pauseButton;

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
    
    _pauseButton = [[UIButton alloc] init];
    _pauseButton.backgroundColor = [UIColor appTintColor];
    _pauseButton.layer.masksToBounds = YES;
    _pauseButton.layer.cornerRadius = 50;
    [_pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [_pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_pauseButton];
    
    [_pauseButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_pauseButton.heightAnchor constraintEqualToConstant:100].active = YES;
    [_pauseButton.widthAnchor constraintEqualToConstant:100].active = YES;
    [_pauseButton.topAnchor constraintEqualToAnchor:_timeLabel.bottomAnchor constant:60].active = YES;

    
    _cancelButton = [[UIButton alloc] init];
    _cancelButton.backgroundColor = [UIColor appTintColor];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = 50;
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_cancelButton];
    
    [_cancelButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_cancelButton.heightAnchor constraintEqualToConstant:100].active = YES;
    [_cancelButton.widthAnchor constraintEqualToConstant:100].active = YES;
    [_cancelButton.topAnchor constraintEqualToAnchor:_pauseButton.bottomAnchor constant:40].active = YES;
    
    
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
