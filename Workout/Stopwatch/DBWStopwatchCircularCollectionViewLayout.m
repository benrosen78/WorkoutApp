//
//  DBWStopwatchCircularCollectionViewLayout.m
//  Workout
//
//  Created by Ben Rosen on 10/10/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWStopwatchCircularCollectionViewLayout.h"
#import "DBWStopwatchCircularCollectionViewLayoutAttributes.h"

@implementation DBWStopwatchCircularCollectionViewLayout

- (CGFloat)anglePerItem {
    return atan(_itemSize.width / _radius);
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self invalidateLayout];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake([self.collectionView numberOfItemsInSection:0] * _itemSize.width, CGRectGetHeight(self.collectionView.bounds));
}

- (Class)layoutAttributesClass {
    return DBWStopwatchCircularCollectionViewLayoutAttributes.class;
}

- (CGFloat)angleAtExtreme {
    return [self.collectionView numberOfItemsInSection:0] > 0 ? -([self.collectionView numberOfItemsInSection:0] - 1) * self.anglePerItem : 0;
}

- (CGFloat)angle {
    return self.angleAtExtreme * self.collectionView.contentOffset.x / (self.collectionViewContentSize.width - CGRectGetWidth(self.collectionView.bounds));
}

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat centerX = self.collectionView.contentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGFloat anchorPointY = ((self.itemSize.height / 2.0) + self.radius) / self.itemSize.height;
    _attributesList = [NSMutableArray array];
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        DBWStopwatchCircularCollectionViewLayoutAttributes *attributes = [DBWStopwatchCircularCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        attributes.size = self.itemSize;
        attributes.anchorPoint = CGPointMake(0.5, anchorPointY);
        attributes.center = CGPointMake(centerX, CGRectGetMidY(self.collectionView.bounds));
        attributes.angle = self.angle + (self.anglePerItem * i);
        [_attributesList addObject:attributes];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attributesList;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _attributesList[indexPath.row];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
