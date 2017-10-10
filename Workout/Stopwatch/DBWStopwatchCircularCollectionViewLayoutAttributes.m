//
//  DBWStopwatchCircularCollectionViewLayoutAttributes.m
//  Workout
//
//  Created by Ben Rosen on 10/10/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatchCircularCollectionViewLayoutAttributes.h"

@implementation DBWStopwatchCircularCollectionViewLayoutAttributes

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    self.zIndex = _angle * 1000;
    self.transform = CGAffineTransformMakeRotation(angle);
}

- (instancetype)copyWithZone:(NSZone *)zone {
    DBWStopwatchCircularCollectionViewLayoutAttributes *copiedAttributes = [super copyWithZone:zone];
    copiedAttributes.angle = _angle;
    copiedAttributes.anchorPoint = _anchorPoint;
    return copiedAttributes;
}

@end
