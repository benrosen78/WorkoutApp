//
//  DBWAboutTableViewController.m
//  Workout
//
//  Created by Ben Rosen on 8/3/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWAboutTableViewController.h"
#import <CompactConstraint/CompactConstraint.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface DBWAboutTableViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation DBWAboutTableViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 300)];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 18;
    iconImageView.image = [UIImage imageNamed:@"ItunesArtwork"];
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:iconImageView];
    
    UILabel *infolabel = [[UILabel alloc] init];
    infolabel.textColor = [UIColor darkGrayColor];
    infolabel.numberOfLines = 0;
    infolabel.textAlignment = NSTextAlignmentCenter;
    infolabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];

    infolabel.text = [NSString stringWithFormat:@"Version: %@\nBuild: %@\n\nThanks for using my app!", version, build];
    infolabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:infolabel];
    
    [headerView addCompactConstraints:@[@"icon.top = header.top + 20",
                                        @"icon.centerX = header.centerX",
                                        @"icon.width = 150",
                                        @"icon.height = 150",
                                        @"info.centerX = header.centerX",
                                        @"info.top = icon.bottom + 10"]
                              metrics:nil
                                views:@{@"icon": iconImageView,
                                        @"info": infolabel,
                                        @"header": headerView
                                        }];

    
    self.tableView.tableHeaderView = headerView;
    self.tableView.scrollEnabled = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
    }

    if (indexPath.row == 0) {
        cell.textLabel.text = @"@benmrosen";
        cell.detailTextLabel.text = @"Twitter";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"ben@benrosen.me";
        cell.detailTextLabel.text = @"Email";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"benrosen.me";
        cell.detailTextLabel.text = @"Website";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self twitterURL]] options:@{} completionHandler:nil];

    } else if (indexPath.row == 1) {
        MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        
        [composeVC setToRecipients:@[@"ben@benrosen.me"]];
        [composeVC setSubject:@"Hello!"];
        [composeVC setMessageBody:@"Hey Ben,\n" isHTML:NO];
        
        [self presentViewController:composeVC animated:YES completion:nil];
    } else if (indexPath.row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://benrosen.me"] options:@{} completionHandler:nil];
    }
    
}

- (NSString *)twitterURL {
    NSString *user = @"benmrosen";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
        return [@"tweetbot:///user_profile/" stringByAppendingString:user];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) {
        return [@"twitterrific:///profile?screen_name=" stringByAppendingString:user];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings://"]]) {
        return [@"tweetings:///user?screen_name=" stringByAppendingString:user];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        return [@"twitter://user?screen_name=" stringByAppendingString:user];
    } else {
        return [@"https://mobile.twitter.com/" stringByAppendingString:user];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
