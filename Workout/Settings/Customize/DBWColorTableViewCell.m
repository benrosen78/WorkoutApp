//
//  DBWColorTableViewCell.m
//  Workout
//
//  Created by Ben Rosen on 8/27/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWColorTableViewCell.h"
#import <CompactConstraint/CompactConstraint.h>

@interface DBWColorTableViewCell ()

@property (strong, nonatomic) UIView *colorView;

@end

@implementation DBWColorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.preservesSuperviewLayoutMargins = YES;
        self.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
        
        _colorView = [[UIView alloc] init];
        _colorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _colorView.layer.borderWidth = 2;
        _colorView.backgroundColor = _color;
        _colorView.layer.masksToBounds = YES;
        _colorView.layer.cornerRadius = 12.5;
        _colorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_colorView];
        
        [self.contentView addCompactConstraints:@[@"color.left = view.left + 10",
                                                  @"color.centerY = view.centerY",
                                                  @"color.width = 25",
                                                  @"color.height = color.width"]
                                        metrics:nil
                                          views:@{@"color": _colorView,
                                                  @"view": self.contentView
                                                  }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _colorView.backgroundColor = _color;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    _colorView.backgroundColor = _color;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    
    _colorView.backgroundColor = color;
}
@end
