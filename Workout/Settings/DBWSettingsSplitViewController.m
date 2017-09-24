//
//  DBWSettingsSplitViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWSettingsSplitViewController.h"
#import "DBWSettingsTableViewController.h"

@implementation DBWSettingsSplitViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        
        DBWSettingsTableViewController *settingsTableViewController = [[DBWSettingsTableViewController alloc] init];
        UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsTableViewController];
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            self.viewControllers = @[rootNavigationController];
            return self;
        }
        
        
        UINavigationController *detailViewController = [[UINavigationController alloc] init];
        detailViewController.navigationBar.prefersLargeTitles = NO;
        
        self.viewControllers = @[rootNavigationController, detailViewController];
    }
    return self;
}

@end
