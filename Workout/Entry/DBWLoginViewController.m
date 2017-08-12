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

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:headerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [[UIImage imageNamed:@"barbelli"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.tintColor = [UIColor whiteColor];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Workout Routine";
    titleLabel.numberOfLines = 0;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"You'll be up and running in just a second.\nChoose to login with Google, Facebook, or an email.";
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.adjustsFontSizeToFitWidth = YES;
    subtitleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
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
    
    UILabel *orLabel = [[UILabel alloc] init];
    orLabel.text = @"OR";
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightSemibold];
    orLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:orLabel];
    
    UIButton *emailButton = [[UIButton alloc] init];
    [emailButton setTitle:@"Sign in with email" forState:UIControlStateNormal];
    emailButton.backgroundColor = [UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00];
    [emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    emailButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    emailButton.layer.masksToBounds = YES;
    emailButton.layer.cornerRadius = 3;
    emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:emailButton];
    
    [self.view addCompactConstraints:@[@"title.bottom = header.bottom - 35",
                                       @"title.left = view.left + 20",
                                       @"title.right = view.right - 20",
                                       @"subtitle.left = title.left",
                                       @"subtitle.right = title.right",
                                       @"subtitle.top = header.bottom+15",
                                       @"header.left = view.left",
                                       @"header.right = view.right",
                                       @"header.top = view.top",
                                       @"header.height = 242",
                                       @"image.centerX = view.centerX",
                                       @"image.top = view.top+44",
                                       @"image.width = 210",
                                       @"image.height = 92",
                                       @"google.centerX = view.centerX",
                                       @"google.top = subtitle.bottom + 40",
                                       @"google.width = view.width - 150",
                                       @"facebook.centerX = view.centerX",
                                       @"facebook.top = google.bottom + 30",
                                       @"facebook.width = google.width - 8",
                                       @"facebook.height = 40",
                                       
                                       @"or.centerX = view.centerX",
                                       @"or.top = facebook.bottom + 20",
                                       @"email.centerX = view.centerX",
                                       @"email.top = or.bottom + 20",
                                       @"email.width = facebook.width",
                                       @"email.height = facebook.height"
                                       ]
                             metrics:nil
                               views:@{@"title": titleLabel,
                                       @"view": self.view,
                                       @"subtitle": subtitleLabel,
                                       @"image": imageView,
                                       @"header": headerView,
                                       @"google": googleButton,
                                       @"facebook": facebookButton,
                                       @"or": orLabel,
                                       @"email": emailButton
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


@end
