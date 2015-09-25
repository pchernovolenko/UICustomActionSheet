//
//  ViewController.m
//  UICustomSheetExample
//
//  Created by Pavlo Chernovolenko on 3/2/15.
//  Copyright (c) 2015 Pavlo Chernovolenko. All rights reserved.
//

#import "ViewController.h"
#import "UICustomActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    NSMutableArray* avatars;
    NSMutableArray* names;
    NSMutableArray* roles;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataSource];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareDataSource {
    
    avatars = [NSMutableArray arrayWithArray:@[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg", @"photo4.gif", @"photo5.jpg", @"photo6.jpg", @"photo7.jpg", @"photo8.jpeg", @"photo9.jpg", @"photo10.jpeg"]];
    names = [NSMutableArray arrayWithArray:@[@"Vladimir Kosmirak", @"Viktor Yanukovitch", @"Robert Brown", @"Paul Black", @"John Smith", @"Angela Merkel", @"Mr. Bin", @"Akhmed", @"Robert Bush", @"Barak Sadface"]];
    roles = [NSMutableArray arrayWithArray:@[@"iOS Developer", @"Refugee", @"Painter", @"Governor", @"Professor", @"Traveler", @"Actor", @"Helicopter Pilot", @"Office worker", @"President"]];
    
}

- (IBAction)presentUICustomActionSheet:(UIButton *)sender {
    
    UICustomActionSheet* actionSheet = [[UICustomActionSheet alloc] initWithTitle:@"Menu Title" delegate:nil buttonTitles:@[@"Cancel",@"Okay"]];
    
    [actionSheet setButtonColors:@[[UIColor redColor]]];
    [actionSheet setBackgroundColor:[UIColor clearColor]];
    [actionSheet setClearLayer:_image.layer];
    [actionSheet setSubtitle:@"Cool subtitle message"];
    [actionSheet setSubtitleColor:[UIColor whiteColor]];
    
    [actionSheet showInView:self.view];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    NSLog(@"%@",[names objectAtIndex:indexPath.row]);
    
    cell.name.text = [names objectAtIndex:indexPath.row];
    cell.role.text = roles[indexPath.row];
    cell.image.image = [UIImage imageNamed:avatars[indexPath.row]];
 
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showAlertForCell:(CustomTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath]];
    
}
 
- (void)showAlertForCell:(CustomTableViewCell *)cell {
    
    UICustomActionSheet* actionSheet = [[UICustomActionSheet alloc] initWithTitle:[cell.name.text isEqualToString:@"Viktor Yanukovitch"] ? @"ОСТАНОВИТЕСЬ!" : [NSString stringWithFormat:@"Want to pick %@?", cell.name.text] delegate:nil buttonTitles:@[@"Cancel",@"Sure"]];
    
    [actionSheet setButtonColors:@[[UIColor redColor],[UIColor colorWithRed:0.0f green:153.0f/255.0f blue:0.0f alpha:1.0f]]];
    [actionSheet setBackgroundColor:[UIColor clearColor]];
    
    CGRect rect = [self.view convertRect:cell.frame fromView:_tableView];
    
    [actionSheet clearLayer:cell.layer withCenter:CGPointMake(rect.origin.x + rect.size.width / 2.0f, rect.origin.y + rect.size.height / 2.0f)];
    
    //[actionSheet setSubtitle:@"Subtitle"];
    [actionSheet setSubtitleColor:[UIColor whiteColor]];
    
    [actionSheet showInView:self.view];
    
}

@end
