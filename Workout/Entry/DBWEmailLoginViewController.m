//
//  DBWEmailLoginViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/15/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWEmailLoginViewController.h"
#import <CompactConstraint/CompactConstraint.h>

@interface DBWEmailLoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSLayoutConstraint *createAccountBottomConstraint;

@end

@implementation DBWEmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Email Login";
    titleLabel.numberOfLines = 0;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];
    
    

    UITextField *usernameField = [[UITextField alloc] init];
    usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.8]}];
    usernameField.delegate = self;
    usernameField.textColor = [UIColor whiteColor];
    usernameField.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    usernameField.layer.masksToBounds = YES;
    usernameField.layer.cornerRadius = 26;
    usernameField.layer.borderWidth = 1.5;
    usernameField.layer.borderColor = [UIColor whiteColor].CGColor;
    usernameField.leftViewMode = UITextFieldViewModeAlways;

    UIImageView *username = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    username.frame = CGRectMake(0.0, 0.0, username.image.size.width + 25.0, username.image.size.height);
    username.contentMode = UIViewContentModeCenter;
    username.tintColor = [UIColor whiteColor];

    usernameField.leftView = username;
    
    
    //usernameField.font = [UIFont systemFontOfSize]
    usernameField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:usernameField];
    


   
    
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.8]}];

    passwordField.delegate = self;
    passwordField.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];

    passwordField.layer.masksToBounds = YES;
    passwordField.layer.cornerRadius = 26;
    passwordField.layer.borderWidth = 1.5;
    passwordField.layer.borderColor = [UIColor whiteColor].CGColor;

    UIImageView *password = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"password"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    password.frame = CGRectMake(0.0, 0.0, password.image.size.width + 25.0, password.image.size.height);
    password.contentMode = UIViewContentModeCenter;
    password.tintColor = [UIColor whiteColor];
    
    passwordField.leftView = password;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    passwordField.textColor = [UIColor whiteColor];
    passwordField.secureTextEntry = YES;
    //usernameField.font = [UIFont systemFontOfSize]
    passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:passwordField];
    

    
    UIButton *signIn = [UIButton buttonWithType:UIButtonTypeCustom];
    signIn.layer.masksToBounds = YES;
    signIn.layer.cornerRadius = 26;
    [signIn addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
    [signIn addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchDown];
    signIn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    [signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    signIn.backgroundColor = [UIColor whiteColor];
    signIn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:signIn];
    
    UIButton *createAccountButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [createAccountButton setTitle:@"Don't have an account yet? Tap to create one." forState:UIControlStateNormal];
    [createAccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createAccountButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    createAccountButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:createAccountButton];
    
    _createAccountBottomConstraint = [self.view addCompactConstraint:@"createAccount.bottom = view.bottom - 10"
                                                             metrics:nil
                                                               views:@{@"createAccount": createAccountButton,
                                                                       @"view": self.view}];
    
    [self.view addCompactConstraints:@[@"title.top = view.top + 30",
                                       @"title.left = view.left + 20",
                                       @"title.right = view.right - 20",

                                       @"usernameField.top = title.bottom + 20",
                                       @"usernameField.centerX = view.centerX",
                                       @"usernameField.width = view.width-110",
                                       @"usernameField.height = 52",

                                       @"passwordField.top = usernameField.bottom + 18",
                                       @"passwordField.centerX = view.centerX",
                                       @"passwordField.width = view.width-110",
                                       @"passwordField.height = 52",
                                       @"signIn.centerX = view.centerX",
                                       @"signIn.width = view.width-110",
                                       @"signIn.top = passwordField.bottom+22",
                                       @"signIn.height = 52",
                                       @"createAccount.centerX = view.centerX",
                                       @"createAccount.height = 60"
                                       
                                       
                                       ]
                             metrics:nil
                               views:@{@"title": titleLabel,
                                       @"view": self.view,
                                       @"usernameField": usernameField,
                                       @"passwordField": passwordField,
                                       @"signIn": signIn,
                                       @"createAccount": createAccountButton
                                       }];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (void)down:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        sender.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

    }];
}

- (void)up:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        sender.backgroundColor = [UIColor whiteColor];
    }];
}

#pragma mark - UITextFieldDelegate

- (void)keyboardShown:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    _createAccountBottomConstraint.constant = -keyboardFrame.size.height;
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardHide:(NSNotification *)notification {
    _createAccountBottomConstraint.constant = -10;
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
