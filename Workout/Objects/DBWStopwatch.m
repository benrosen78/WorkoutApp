//
//  DBWStopwatch.m
//  Workout
//
//  Created by Ben Rosen on 10/29/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatch.h"

@implementation DBWStopwatch

- (NSString *)formattedTimeString {
    return [NSString stringWithFormat:@"%lu:%02lu", self.minutes, self.seconds];
}

@end
