//
//  DBWAuthenticationManager.h
//  Workout
//
//  Created by Ben Rosen on 8/11/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DBWAuthenticationManagerLogInNotification = @"DBWAuthenticationManagerLogInNotification";

@interface DBWAuthenticationManager : NSObject

+ (void)googleAuthenticationWithToken:(NSString *)token;

+ (void)facebookAuthenticationWithToken:(NSString *)token;

+ (BOOL)loggedIn;

@end
