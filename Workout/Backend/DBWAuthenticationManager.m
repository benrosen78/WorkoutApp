//
//  DBWAuthenticationManager.m
//  Workout
//
//  Created by Ben Rosen on 8/11/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWAuthenticationManager.h"
#import <Realm/Realm.h>
#import "DBWDatabaseManager.h"

static NSString *const serverStringURL = @"https://wa.benrosen.me/";

@implementation DBWAuthenticationManager

+ (void)googleAuthenticationWithToken:(NSString *)token {
    RLMSyncCredentials *googleCredentials = [RLMSyncCredentials credentialsWithGoogleToken:token];
    [self loginWithAuthentication:googleCredentials];
}

+ (void)facebookAuthenticationWithToken:(NSString *)token {
    RLMSyncCredentials *facebookCredentials = [RLMSyncCredentials credentialsWithFacebookToken:token];
    [self loginWithAuthentication:facebookCredentials];
}

+ (void)emailAuthenticationWithUsername:(NSString *)username password:(NSString *)password register:(BOOL)registerAccount {
    RLMSyncCredentials *emailCredentials = [RLMSyncCredentials credentialsWithUsername:username password:password register:registerAccount];
    [self loginWithAuthentication:emailCredentials];
}

+ (void)loginWithAuthentication:(RLMSyncCredentials *)credentials {
    [RLMSyncUser logInWithCredentials:credentials authServerURL:[NSURL URLWithString:serverStringURL] onCompletion:^(RLMSyncUser *user, NSError *error) {
        if (user) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DBWAuthenticationManagerLogInNotification object:nil];
            [DBWDatabaseManager performSelectorOnMainThread:@selector(sharedDatabaseManager) withObject:nil waitUntilDone:nil];
         }
    }];
}

+ (BOOL)loggedIn {
    return [RLMSyncUser currentUser];
}

@end
