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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.201 green:0.220 blue:0.376 alpha:1.00]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor clearColor];
    [_window makeKeyAndVisible];
    
    [DBWWorkoutManager directoryInitialization];
    
    DBWWorkoutTodayViewController *todayVC = [[DBWWorkoutTodayViewController alloc] init];
    todayVC.title = @"Today's Gains";
    
    DBWWorkoutCalendarViewController *calendarVC = [[DBWWorkoutCalendarViewController alloc] init];
    calendarVC.title = @"Past Gains";
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:calendarVC], [[UINavigationController alloc] initWithRootViewController:todayVC]];
    
    _window.rootViewController = tab;
    
    return YES;
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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
