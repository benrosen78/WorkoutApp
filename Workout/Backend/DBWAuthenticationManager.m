//
//  DBWAuthenticationManager.m
//  Workout
//
//  Created by Ben Rosen on 8/11/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWAuthenticationManager.h"
#import <Realm/Realm.h>

@interface Dog : RLMObject

@property NSString *name;

@end

@implementation Dog

@end


static NSString *const serverStringURL = @"https://wa.benrosen.me/";

@implementation DBWAuthenticationManager

+ (void)googleAuthenticationWithToken:(NSString *)token {
    RLMSyncCredentials *googleCredentials = [RLMSyncCredentials credentialsWithGoogleToken:token];
    [self loginWithAuthentication:googleCredentials];
}

+ (void)facebookAuthenticationWithToken:(NSString *)token {
    RLMSyncCredentials *facebookCredentials = [RLMSyncCredentials credentialsWithFacebookToken:token];
    NSLog(@"%@ fac", facebookCredentials.token);
    [self loginWithAuthentication:facebookCredentials];
}

+ (void)loginWithAuthentication:(RLMSyncCredentials *)credentials {
    [RLMSyncUser logInWithCredentials:credentials
                        authServerURL:[NSURL URLWithString:serverStringURL]
                         onCompletion:^(RLMSyncUser *user, NSError *error) {
                             NSLog(@"error %@", error);
                             NSLog(@"user %@", user);
                             if (user) {
                                 RLMRealm *realm = [RLMRealm defaultRealm];
                                 [realm beginWriteTransaction];
                                 [realm addObject:[[Dog alloc] init]];
                                 [realm commitWriteTransaction];
                                 // can now open a synchronized RLMRealm with this user
                                 RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:[serverStringURL stringByAppendingPathComponent:@"~/tests"]]];
                                 //[realm addObject:[[Dog alloc] initWithValue:@{@"name": @"Franklin"}]];
                             } else if (error) {
                                 // handle error
                                 NSLog(@"error: %@", error);
                                 RLMRealm *realm = [RLMRealm defaultRealm];
                                 [realm beginWriteTransaction];
                                 [realm addObject:[[Dog alloc] init]];
                                 [realm commitWriteTransaction];
                             }
                         }];
}

@end
