//
//  DBWExercisePlaceholderCreationNamingViewController.m
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePlaceholderCreationNamingViewController.h"

@interface DBWExercisePlaceholderCreationNamingViewController ()

@end

@implementation DBWExercisePlaceholderCreationNamingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Name the Exercise";
    title.font = [UIFont systemFontOfSize:26 weight:UIFontWeightSemibold];
    title.textAlignment = NSTextAlignmentCenter;
    title.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:title];
    
    
    [title.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:17].active = YES;
    [title.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
}

@end
