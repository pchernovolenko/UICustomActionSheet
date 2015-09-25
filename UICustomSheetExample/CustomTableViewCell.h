//
//  CustomTableViewCell.h
//  UICustomSheetExample
//
//  Created by Pavlo Chernovolenko on 9/25/15.
//  Copyright © 2015 Pavlo Chernovolenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTableViewCell;

@protocol CellProtocol <NSObject>

- (void)showAlertForCell:(CustomTableViewCell *)cell;

@end

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *role;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) id <CellProtocol> delegate;

- (IBAction)addAction:(id)sender;
- (IBAction)infoAction:(id)sender;

@end
