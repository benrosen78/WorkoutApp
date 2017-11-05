//
//  DBWLoginViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/11/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWLoginViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Realm/Realm.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DBWAuthenticationManager.h"
#import "AppDelegate.h"
#import "DBWEmailLoginViewController.h"

@interface DBWLoginViewController () <GIDSignInUIDelegate, FBSDKLoginButtonDelegate>

@end

@implementation DBWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"test");
    }

    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(loggedIn:) name:DBWAuthenticationManagerLogInNotification object:nil];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    //UIView *headerView = [[UIView alloc] init];
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.image = [UIImage imageNamed:@"gym-large"];
    //headerView.backgroundColor = [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:headerView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.alpha = 0.7;
    [blurEffectView setFrame:self.view.bounds];
    [self.view addSubview:blurEffectView];
    
    UIImageView *barbellImageView = [[UIImageView alloc] init];
    barbellImageView.image = [[UIImage imageNamed:@"barbelli"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    barbellImageView.tintColor = [UIColor whiteColor];
    barbellImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:barbellImageView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Gym Notebook";
    titleLabel.numberOfLines = 0;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];
    //[titleLabel.topAnchor constraint]
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"Hello.\nChoose an option to sign in";
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.adjustsFontSizeToFitWidth = YES;
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.font = [UIFont systemFontOfSize:35 weight:UIFontWeightLight];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:subtitleLabel];

    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].serverClientID = @"391663085222-i6ldqlkqeht2opn1b8bpchd14aeefg05.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].clientID = @"391663085222-i6ldqlkqeht2opn1b8bpchd14aeefg05.apps.googleusercontent.com";
    GIDSignInButton *googleButton = [[GIDSignInButton alloc] init];
    googleButton.style = kGIDSignInButtonStyleWide;
    //button.colorScheme = kGIDSignInButtonColorSchemeDark;
    //[googleButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    //[googleButton addTarget:self action:@selector(googleTapped:) forControlEvents:UIControlEventTouchUpInside];
    googleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:googleButton];
    
    FBSDKLoginButton *facebookButton = [[FBSDKLoginButton alloc] init];
    facebookButton.readPermissions = @[@"email"];
    facebookButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    [facebookButton removeConstraints:facebookButton.constraints];
    facebookButton.delegate = self;
    facebookButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:facebookButton];
    
    
    UIButton *emailButton = [[UIButton alloc] init];
    [emailButton addTarget:self action:@selector(emailTapped:) forControlEvents:UIControlEventTouchUpInside];
    [emailButton setTitle:@"Sign in with email" forState:UIControlStateNormal];
    emailButton.backgroundColor = [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00];
    [emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    emailButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    emailButton.layer.masksToBounds = YES;
    emailButton.layer.cornerRadius = 3;
    emailButton.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    emailButton.layer.shadowOffset = CGSizeMake(0, 1.0f);
    emailButton.layer.shadowOpacity = 0.7f;
    emailButton.layer.shadowRadius = 0.0f;
    emailButton.layer.masksToBounds = NO;
    emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:emailButton];

    [self.view addCompactConstraints:@[

                                       @"header.left = view.left",
                                       @"header.right = view.right",
                                       @"header.top = view.top",
                                       @"header.bottom = view.bottom",
                                       @"barbell.leading = view.leading + 50",
                                       @"barbell.top = view.top + 150",
                                       @"title.top = barbell.bottom + 7",
                                       @"title.left = barbell.left",
                                       @"subtitle.top = title.bottom + 50",
                                       @"subtitle.left = title.left",
                                       @"subtitle.right = view.right - 50",


                                       @"google.top = subtitle.bottom + 40",
                                       @"google.left = subtitle.left",
                                       @"google.right = subtitle.right",

                                       @"facebook.top = google.bottom + 30",
                                       @"facebook.left = google.left + 4",
                                       @"facebook.right = google.right - 4",
                                       @"facebook.height = 40",
                                    
                                       @"email.top = facebook.bottom + 30",
                                       @"email.left = google.left + 4",
                                       @"email.right = google.right - 4",
                                       @"email.height = facebook.height"
                                       ]
                             metrics:nil
                               views:@{@"title": titleLabel,
                                       @"view": self.view,
                                       @"subtitle": subtitleLabel,
                                       @"header": headerView,
                                       @"google": googleButton,
                                       @"facebook": facebookButton,
                                       @"email": emailButton,
                                       @"barbell": barbellImageView
                                       }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {    
    [DBWAuthenticationManager facebookAuthenticationWithToken:[FBSDKAccessToken currentAccessToken].tokenString];
}

- (void)loggedIn:(NSNotification *)notification {
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImageView __block *transitioningView = [[UIImageView alloc] initWithFrame:self.view.frame];
        transitioningView.backgroundColor = [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00];
        transitioningView.alpha = 0.0;
        [self.view.window addSubview:transitioningView];
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            transitioningView.alpha = 1.0;
        } completion:^(BOOL finished) {
            AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
            self.view.window.rootViewController = delegate.tabBarController;
            
            [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                transitioningView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [transitioningView removeFromSuperview];
                
                for (int i = (int)[self.view.subviews count] - 1; i >= 0; i--) {
                    UIView *subview = self.view.subviews[i];
                    [subview removeFromSuperview];
                }
            }];
        }];
    });

}

- (void)emailTapped:(UIButton *)tapped {
    DBWEmailLoginViewController *loginViewController = [[DBWEmailLoginViewController alloc] init];
    loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

@end
