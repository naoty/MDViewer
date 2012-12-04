//
//  MDLoginViewController.h
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MDLoginViewController : UITableViewController <UITextFieldDelegate>
{
    UITextField *_emailField;
    UITextField *_passwordField;
}

- (IBAction)didPushButton:(id)sender;

@end
