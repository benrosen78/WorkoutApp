//
//  DBWExercisePlaceholderCreationNamingViewController.m
//  Workout
//
//  Created by Ben Rosen on 11/12/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExercisePlaceholderCreationNamingViewController.h"
#import "UIColor+ColorPalette.h"

@interface DBWExercisePlaceholderCreationNamingViewController ()

@property (strong, nonatomic) UITextField *nameTextField;

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
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_dumbbell"]];
    nameImageView.frame = CGRectMake(0.0, 0.0, nameImageView.image.size.width + 30.0, nameImageView.image.size.height);
    nameImageView.contentMode = UIViewContentModeCenter;
    
    
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.placeholder = @"Partial squats";
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    _nameTextField.leftView = nameImageView;
    _nameTextField.textAlignment = NSTextAlignmentLeft;
    _nameTextField.layer.masksToBounds = YES;
    _nameTextField.layer.cornerRadius = 15;
    _nameTextField.layer.borderWidth = 1;
    _nameTextField.layer.borderColor = [UIColor colorWithRed:0.929 green:0.922 blue:0.933 alpha:1.00].CGColor;
    _nameTextField.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_nameTextField];
    
    [_nameTextField.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:25].active = YES;
    [_nameTextField.heightAnchor constraintEqualToConstant:55].active = YES;
    [_nameTextField.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:60].active = YES;
    [_nameTextField.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-60].active = YES;

    UIButton *doneButton = [[UIButton alloc] init];
    [doneButton addTarget:self action:@selector(addExercise) forControlEvents:UIControlEventTouchUpInside];
    doneButton.layer.masksToBounds = YES;
    doneButton.layer.cornerRadius = 14;
    doneButton.backgroundColor = [UIColor appTintColor];
    [doneButton setTitle:@"Add Exercise" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightMedium];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:doneButton];
    [doneButton.topAnchor constraintEqualToAnchor:_nameTextField.bottomAnchor constant:30].active = YES;
    [doneButton.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:75].active = YES;
    [doneButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-75].active = YES;
    [doneButton.heightAnchor constraintEqualToConstant:45].active = YES;
}

- (void)addExercise {
    [_nameTextField resignFirstResponder];
    [self.completionDelegate exerciseNamed:_nameTextField.text];
}

@end
