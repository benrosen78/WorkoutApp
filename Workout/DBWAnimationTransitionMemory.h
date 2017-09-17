//
//  DBWAnimationTransitionMemory.h
//  Workout
//
//  Created by Ben Rosen on 9/16/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBWAnimationTransitionMemory : NSObject

@property (strong, nonatomic) UIView *pushSnapshotCellView, *popSnapshotCellView;

@property (nonatomic) CGRect originalCellFrame;

+ (instancetype)sharedInstance;

@end
