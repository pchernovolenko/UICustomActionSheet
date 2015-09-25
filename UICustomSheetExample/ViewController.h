//
//  ViewController.h
//  UICustomSheetExample
//
//  Created by Pavlo Chernovolenko on 3/2/15.
//  Copyright (c) 2015 Pavlo Chernovolenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

@interface ViewController : UIViewController <CellProtocol>

- (IBAction)presentUICustomActionSheet:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

