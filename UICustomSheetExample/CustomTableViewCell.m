//
//  CustomTableViewCell.m
//  UICustomSheetExample
//
//  Created by Pavlo Chernovolenko on 9/25/15.
//  Copyright © 2015 Pavlo Chernovolenko. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addAction:(id)sender {
    
    [self.delegate showAlertForCell:self];
    
}

- (IBAction)infoAction:(id)sender {
    
    [self.delegate showAlertForCell:self];
    
}
@end
