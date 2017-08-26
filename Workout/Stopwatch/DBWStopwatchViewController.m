//
//  DBWStopwatchViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/26/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatchViewController.h"
#import <CompactConstraint/CompactConstraint.h>

@interface DBWStopwatchViewController ()

@end

@implementation DBWStopwatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];
    
    UILabel *detailTitleLabel = [[UILabel alloc] init];
    detailTitleLabel.text = @"Pick a stopwatch time and tap Start. If you would like to customize these, go to settings.";
    detailTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    detailTitleLabel.textAlignment = NSTextAlignmentCenter;
    detailTitleLabel.adjustsFontSizeToFitWidth = YES;
    detailTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:detailTitleLabel];
    
    [self.view addCompactConstraints:@[@"titleLabel.centerX = view.centerX",
                                       @"titleLabel.top = view.top + 100",
                                       @"titleLabel.width = view.width - spacing",
                                       @"detail.top = titleLabel.bottom + 20",
                                       @"detail.centerX = view.centerX",
                                       @"detail.width = view.width - spacing"]
                             metrics:@{@"spacing": UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @320 : @40}
                               views:@{@"titleLabel": titleLabel,
                                       @"detail": detailTitleLabel,
                                       @"view": self.view
                                       }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
