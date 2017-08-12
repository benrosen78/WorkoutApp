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

@interface DBWLoginViewController () <GIDSignInUIDelegate, FBSDKLoginButtonDelegate>

@end

@implementation DBWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter ] addObserverForName:FBSDKAccessTokenDidChangeNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@" notification test %@", [FBSDKAccessToken currentAccessToken]);
    }];
    
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
    emailButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
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
                                       @"facebook.width = google.width",
                                       @"or.centerX = view.centerX",
                                       @"or.top = facebook.bottom + 20",
                                       @"email.centerX = view.centerX",
                                       @"email.top = or.bottom + 20",
                                       @"email.width = google.width"
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

- (void)googleTapped:(GIDSignInButton *)button {
    //RLMSyncCredentials *googleCredentials = [RLMSyncCredentials credentialsWithGoogleToken:@""];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    NSLog(@"error: %@", error);
    NSLog(@"result = %@, %@, %@", result, [FBSDKAccessToken currentAccessToken], result.token.tokenString);
    [DBWAuthenticationManager facebookAuthenticationWithToken:[FBSDKAccessToken currentAccessToken]];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

@end
