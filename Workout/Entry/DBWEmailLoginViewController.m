//
//  DBWEmailLoginViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/15/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWEmailLoginViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import "DBWAuthenticationManager.h"

@interface DBWEmailLoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSLayoutConstraint *createAccountBottomConstraint;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *signIn, *createAccountButton;

@property (strong, nonatomic) UITextField *usernameField, *passwordField;

@property (nonatomic) BOOL login;

@end

@implementation DBWEmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _login = YES;
    
    self.view.backgroundColor =  [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"Email Login";
    _titleLabel.numberOfLines = 0;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_titleLabel];
    
    

    _usernameField = [[UITextField alloc] init];
    _usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.8]}];
    _usernameField.delegate = self;
    _usernameField.textColor = [UIColor whiteColor];
    _usernameField.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    _usernameField.layer.masksToBounds = YES;
    _usernameField.layer.cornerRadius = 26;
    _usernameField.layer.borderWidth = 1.5;
    _usernameField.layer.borderColor = [UIColor whiteColor].CGColor;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;

    UIImageView *username = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    username.frame = CGRectMake(0.0, 0.0, username.image.size.width + 25.0, username.image.size.height);
    username.contentMode = UIViewContentModeCenter;
    username.tintColor = [UIColor whiteColor];

    _usernameField.leftView = username;
    
    
    //usernameField.font = [UIFont systemFontOfSize]
    _usernameField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_usernameField];
    


   
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.8]}];

    _passwordField.delegate = self;
    _passwordField.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];

    _passwordField.layer.masksToBounds = YES;
    _passwordField.layer.cornerRadius = 26;
    _passwordField.layer.borderWidth = 1.5;
    _passwordField.layer.borderColor = [UIColor whiteColor].CGColor;

    UIImageView *password = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"password"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    password.frame = CGRectMake(0.0, 0.0, password.image.size.width + 25.0, password.image.size.height);
    password.contentMode = UIViewContentModeCenter;
    password.tintColor = [UIColor whiteColor];
    
    _passwordField.leftView = password;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.textColor = [UIColor whiteColor];
    _passwordField.secureTextEntry = YES;
    //usernameField.font = [UIFont systemFontOfSize]
    _passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_passwordField];
    

    
    _signIn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signIn.layer.masksToBounds = YES;
    _signIn.layer.cornerRadius = 26;
    [_signIn addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
    [_signIn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [_signIn addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchDown];
    _signIn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    [_signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    [_signIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _signIn.backgroundColor = [UIColor whiteColor];
    _signIn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_signIn];
    
    _createAccountButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_createAccountButton setTitle:@"Don't have an account yet? Tap to create one." forState:UIControlStateNormal];
    [_createAccountButton addTarget:self action:@selector(createAccount:) forControlEvents:UIControlEventTouchUpInside];
    [_createAccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _createAccountButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    _createAccountButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_createAccountButton];
    
    _createAccountBottomConstraint = [self.view addCompactConstraint:@"createAccount.bottom = view.bottom - 10"
                                                             metrics:nil
                                                               views:@{@"createAccount": _createAccountButton,
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
                               views:@{@"title": _titleLabel,
                                       @"view": self.view,
                                       @"usernameField": _usernameField,
                                       @"passwordField": _passwordField,
                                       @"signIn": _signIn,
                                       @"createAccount": _createAccountButton
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

- (void)signIn:(UIButton *)sender {
    // login or sign up
    [DBWAuthenticationManager emailAuthenticationWithUsername:_usernameField.text password:_passwordField.text register:!_login];
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

- (void)createAccount:(UIButton *)button {
    _login = !_login;
    
    if (_login) {
        _titleLabel.text = @"Email Login";
        [_signIn setTitle:@"Sign In" forState:UIControlStateNormal];
        [_createAccountButton setTitle:@"Don't have an account yet? Tap to create one." forState:UIControlStateNormal];
    } else {
        _titleLabel.text = @"Email Sign-up";
        [_signIn setTitle:@"Sign Up" forState:UIControlStateNormal];
        [_createAccountButton setTitle:@"Have an account? Click to login." forState:UIControlStateNormal];
    }
}

@end
