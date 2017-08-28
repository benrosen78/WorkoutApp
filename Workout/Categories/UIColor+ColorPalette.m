//
//  UIColor+ColorPalette.m
//  Workout
//
//  Created by Ben Rosen on 8/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "UIColor+ColorPalette.h"

@implementation UIColor (ColorPalette)

+ (NSArray *)calendarColors {
    return @[[UIColor colorWithRed:1.000 green:0.231 blue:0.188 alpha:1.00], // red
             [UIColor colorWithRed:1.000 green:0.584 blue:0.000 alpha:1.00], // orange
             [UIColor colorWithRed:1.000 green:0.800 blue:0.000 alpha:1.00], // yellow
             [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:1.00], // green
             [UIColor colorWithRed:0.353 green:0.784 blue:0.980 alpha:1.00], // teal blue
             [UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.00], // blue
             [UIColor colorWithRed:0.345 green:0.337 blue:0.839 alpha:1.00], // purple
             [UIColor colorWithRed:1.000 green:0.176 blue:0.333 alpha:1.00]  // pink
             ];
}

@end
