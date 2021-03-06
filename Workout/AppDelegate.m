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
#import "DBWSettingsTableViewController.h"
#import "DBWLoginViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DBWAuthenticationManager.h"
#import <Realm/Realm.h>
#import "DBWDatabaseManager.h"
#import "DBWStopwatchViewController.h"
#import "DBWSettingsSplitViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <GIDSignInDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GIDSignIn sharedInstance].delegate = self;
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    // notification stuff
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"Notification status: %d, %@", granted, error);
    }];
    
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
   // [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
 //   [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00]];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //[[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setPrefersLargeTitles:YES];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00]];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor clearColor];
    [_window makeKeyAndVisible];
    
    //[DBWWorkoutManager directoryInitialization];
    
    DBWWorkoutTodayViewController *todayVC = [[DBWWorkoutTodayViewController alloc] init];
    todayVC.title = @"Today's Gains";
    todayVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Today's Gains" image:[[UIImage imageNamed:@"today"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:0];
    
    DBWWorkoutCalendarViewController *calendarVC = [[DBWWorkoutCalendarViewController alloc] init];
    calendarVC.title = @"Past Gains";
    calendarVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Today's Gains" image:[[UIImage imageNamed:@"calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:1];
    
    DBWStopwatchViewController *stopwatchVC = [[DBWStopwatchViewController alloc] init];
    stopwatchVC.title = @"Stopwatch";
    stopwatchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Stopwatch" image:[[UIImage imageNamed:@"stopwatch"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:2];
    
    DBWSettingsSplitViewController *settingsVC = [[DBWSettingsSplitViewController alloc] init];
    settingsVC.title = @"Settings";
    settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:3];
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:calendarVC], [[UINavigationController alloc] initWithRootViewController:todayVC], [[UINavigationController alloc] initWithRootViewController:stopwatchVC], settingsVC];
    _tabBarController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    
    _loginVC = [[DBWLoginViewController alloc] init];
    
    //[[RLMSyncUser currentUser] logOut];
    if (![DBWAuthenticationManager loggedIn]) {
        _window.rootViewController = _loginVC;
    } else {
        
        _window.rootViewController = _tabBarController;
        
        /*UIViewController *controller = [[UIStoryboard storyboardWithName:@"Launch Screen" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
         controller.view.backgroundColor = [UIColor clearColor];
         [_window.rootViewController.view addSubview:controller.view];*/
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return YES;
    } else if ([[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return YES;
    }
    return NO;
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    [DBWAuthenticationManager googleAuthenticationWithToken:user.authentication.idToken];
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
