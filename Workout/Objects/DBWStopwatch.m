//
//  DBWStopwatch.m
//  Workout
//
//  Created by Ben Rosen on 10/29/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatch.h"

@implementation DBWStopwatch

- (NSString *)textRepresentation {
    return [NSString stringWithFormat:@"%li:%li", (long)_minutes, (long)_seconds];
}

@end
