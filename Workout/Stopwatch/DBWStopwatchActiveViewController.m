//
//  DBWStopwatchActiveViewController.m
//  Workout
//
//  Created by Ben Rosen on 10/21/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatchActiveViewController.h"
#import "UIColor+ColorPalette.h"
#import "DBWStopwatch.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotifications/UNUserNotificationCenter.h>

static NSString *const DBWStopwatchRestPeriodNotification = @"DBWStopwatchRestPeriodNotification";

@interface DBWStopwatchActiveViewController ()

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIButton *cancelButton, *pauseButton;

@property (strong, nonatomic) DBWStopwatch *stopwatch;

@property (nonatomic, readwrite) NSTimeInterval startingTime;

@end

@implementation DBWStopwatchActiveViewController

- (instancetype)initWithStopwatch:(DBWStopwatch *)stopwatch {
    if (self = [super init]) {
        _stopwatch = stopwatch;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:100 weight:UIFontWeightLight];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_timeLabel];
    
    [_timeLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_timeLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [_timeLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:80].active = YES;

    self.view.backgroundColor = [UIColor clearColor];
    
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
    [_cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_cancelButton];
    
    [_cancelButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_cancelButton.heightAnchor constraintEqualToConstant:100].active = YES;
    [_cancelButton.widthAnchor constraintEqualToConstant:100].active = YES;
    [_cancelButton.topAnchor constraintEqualToAnchor:_pauseButton.bottomAnchor constant:40].active = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_startingTime == 0) {
        _timeLabel.text = _stopwatch.formattedTimeString;
        _startingTime = [[NSDate date] timeIntervalSince1970] + 1;
        [self performSelector:@selector(timerFired) withObject:nil afterDelay:1];
        
        // create the notification content
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.body = @"Your rest period is over. Come back and finish your sets!";
        content.sound = [UNNotificationSound defaultSound];

        
        // schedule it for x seconds from now
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_stopwatch.minutes * 60 + _stopwatch.seconds + 1];
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear + NSCalendarUnitMonth + NSCalendarUnitHour + NSCalendarUnitMinute + NSCalendarUnitSecond fromDate:date];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:DBWStopwatchRestPeriodNotification content:content trigger:trigger];
    
        // dispatch it
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Notification error: %@",error);
            }
        }];
    }
}

- (void)timerFired {
    NSTimeInterval dateNow = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval difference = dateNow - _startingTime;
    
    NSTimeInterval timeLeft = _stopwatch.minutes * 60 + _stopwatch.seconds - difference;
    NSInteger minutes = timeLeft / 60;
    NSInteger seconds = (int)timeLeft % 60;

    _timeLabel.text = [NSString stringWithFormat:@"%lu:%02lu", minutes, seconds];
    
    if (minutes != 0 || seconds != 0) {
        [self performSelector:@selector(timerFired) withObject:nil afterDelay:1.0];
    } else {
        [self timerFinished];
    }
}

- (void)timerFinished {
    UINotificationFeedbackGenerator *feedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
    for (int i = 0; i < 3; i++) {
        [feedbackGenerator notificationOccurred:UINotificationFeedbackTypeSuccess];
    }

    _timeLabel.transform = CGAffineTransformMakeTranslation(4.0, 0);
    
    [UIView animateWithDuration:0.04 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        UIView.animationRepeatCount = 4;
        _timeLabel.transform = CGAffineTransformMakeTranslation(-4.0, 0);
    } completion:^(BOOL finished) {
        _timeLabel.transform = CGAffineTransformIdentity;
        [self.delegate stopwatchCompleted];
    }];
    
    
}

- (void)cancelTapped {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[DBWStopwatchRestPeriodNotification]];
    [self.delegate stopwatchCompleted];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
