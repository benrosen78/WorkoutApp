//
//  DBWStopwatchCircularCollectionViewLayout.h
//  Workout
//
//  Created by Ben Rosen on 10/10/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBWStopwatchCircularCollectionViewLayoutAttributes;

@interface DBWStopwatchCircularCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, readwrite) CGSize itemSize;

@property (nonatomic, readwrite) CGFloat radius;

- (CGFloat)anglePerItem;

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesList;

@end
