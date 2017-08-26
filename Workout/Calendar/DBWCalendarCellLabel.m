//
//  DBWCalendarCellLabel.m
//  Workout
//
//  Created by Ben Rosen on 8/26/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWCalendarCellLabel.h"

@implementation DBWCalendarCellLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 9, 0, 9};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
