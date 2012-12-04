//
//  MDLoginViewController.h
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDLoginViewController : UITableViewController <UITextFieldDelegate>
{
    UITextField *_emailField;
    UITextField *_passwordField;
}

@end
