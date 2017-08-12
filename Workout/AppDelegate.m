//
//  AppDelegate.m
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "AppDelegate.h"
#import "DBWWorkoutTodayViewController.h"
#import "DBWWorkoutCalendarViewController.h"
#import "DBWWorkoutManager.h"
#import "DBWSettingsTableViewController.h"
#import "DBWLoginViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DBWAuthenticationManager.h"

@interface AppDelegate () <GIDSignInDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GIDSignIn sharedInstance].delegate = self;
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00]];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor clearColor];
    [_window makeKeyAndVisible];
    
    [DBWWorkoutManager directoryInitialization];
    
    DBWLoginViewController *loginVC = [[DBWLoginViewController alloc] init];
    _window.rootViewController = loginVC;
    return YES;
    
    DBWWorkoutTodayViewController *todayVC = [[DBWWorkoutTodayViewController alloc] init];
    todayVC.title = @"Today's Gains";
    todayVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Today's Gains" image:[[UIImage imageNamed:@"today"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:0];
    
    DBWWorkoutCalendarViewController *calendarVC = [[DBWWorkoutCalendarViewController alloc] init];
    calendarVC.title = @"Past Gains";
    calendarVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Today's Gains" image:[[UIImage imageNamed:@"calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:1];

    DBWSettingsTableViewController *settingsVC = [[DBWSettingsTableViewController alloc] init];
    settingsVC.title = @"Settings";
    settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:2];
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:calendarVC], [[UINavigationController alloc] initWithRootViewController:todayVC], [[UINavigationController alloc] initWithRootViewController:settingsVC]];
    
    _window.rootViewController = tab;
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    if ([[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]) {
        return YES;
    } else if ([[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationLaunchOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]) {
        return YES;
    }
    return NO;

}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    NSLog(@"%@ %@ %@ %@ %@ %@", userId, idToken, fullName, givenName, familyName, email);
    [DBWAuthenticationManager googleAuthenticationWithToken:idToken];
    // ...
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
