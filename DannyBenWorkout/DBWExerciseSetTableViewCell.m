//
//  DBWExerciseSetTableViewCell.m
//  Workout
//
//  Created by Ben Rosen on 8/2/17.
//  Copyright © 2017 Ben Rosen. All rights reserved.
//

#import "DBWExerciseSetTableViewCell.h"
#import <CompactConstraint/CompactConstraint.h>

@implementation DBWExerciseSetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [UIColor colorWithRed:0.784 green:0.780 blue:0.800 alpha:1.00];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:separator];
        
        [self.contentView addCompactConstraints:@[@"separator.left = view.left",
                                                  @"separator.right = view.right",
                                                  @"separator.height = 0.5",
                                                  @"separator.centerY = view.centerY"]
                                        metrics:nil
                                          views:@{@"separator": separator,
                                                  @"view": self.contentView
                                                  }];
        NSMutableArray *textFields = [NSMutableArray arrayWithCapacity:2];
        for (int i = 0; i < 2; i++) {
            UIView *containerView = [[UIView alloc] init];
            containerView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:containerView];
        
            [self.contentView addCompactConstraints:@[@"containerView.left = view.left",
                                                      @"containerView.right = view.right",
                                                      i == 0 ? @"containerView.top = view.top" : @"containerView.bottom = view.bottom",
                                                      @"containerView.height = view.height / 2"
                                                      ]
                                            metrics:nil
                                              views:@{@"containerView": containerView,
                                                      @"view": self.contentView
                                                      }];
            
            
            UITextField *textField = [[UITextField alloc] init];
            textField.adjustsFontSizeToFitWidth = YES;
            textField.textColor = [UIColor blackColor];
            textField.placeholder = i == 0 ? @"Weight" : @"Reps";
            textField.keyboardType = i == 0 ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad;
            textField.textAlignment = NSTextAlignmentRight;
            textField.returnKeyType = UIReturnKeyDone;
            textField.backgroundColor = [UIColor whiteColor];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.clearButtonMode = UITextFieldViewModeNever;
            [textField setEnabled: YES];
            textField.translatesAutoresizingMaskIntoConstraints = NO;
            [textFields addObject:textField];
            [containerView addSubview:textField];
            
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            label.text = i == 0 ? @"Weight" : @"Reps";
            label.textAlignment = NSTextAlignmentLeft;
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [containerView addSubview:label];
            
            [containerView addCompactConstraints:@[@"text.right = view.right - 10",
                                                      @"text.centerY = view.centerY",
                                                      @"label.left = view.left + 10",
                                                      @"label.centerY = view.centerY"]
                                            metrics:nil
                                              views:@{@"text": textField,
                                                      @"label": label,
                                                      @"view": containerView
                                                      }];
        }
        _textFields = [NSArray arrayWithArray:textFields];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
