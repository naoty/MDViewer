//
//  MDLoginViewController.m
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDLoginViewController.h"

@interface MDLoginViewController ()

@end

@implementation MDLoginViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Label
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 85, 21)];
    textLabel.text = indexPath.row == 0 ? @"Email" : @"Password";
    textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    textLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:textLabel];
    
    // TextField
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(103, 11, 177, 21)];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:17.0f];
    textField.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
    textField.textAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = indexPath.row == 0 ? UIKeyboardTypeEmailAddress : UIKeyboardTypeASCIICapable;
    textField.returnKeyType = indexPath.row == 0 ? UIReturnKeyNext : UIReturnKeyDone;
    textField.secureTextEntry = indexPath.row == 0 ? NO : YES;
    [cell.contentView addSubview:textField];
    
    if (indexPath.row == 0) {
        _emailField = textField;
    } else {
        _passwordField = textField;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [_emailField becomeFirstResponder];
    } else {
        [_passwordField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _emailField) {
        [_passwordField becomeFirstResponder];
    } else {
        [_passwordField resignFirstResponder];
        // send request
        
    }
    return YES;
}

@end
