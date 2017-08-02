//
//  DBWSet.h
//  DannyBenWorkout
//
//  Created by Ben Rosen on 7/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DBWSet : NSObject <NSCoding>

@property (nonatomic) NSInteger reps;

@property (nonatomic) CGFloat weight;

@end
