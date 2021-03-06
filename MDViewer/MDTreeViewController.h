//
//  MDTreeViewController.h
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "MDLoginDelegate.h"

@class MDViewerController;
@class MBProgressHUD;

@interface MDTreeViewController : UITableViewController <DBRestClientDelegate, MDLoginDelegate>
{
    DBRestClient *_restClient;
    NSMutableArray *_files;
    NSFileManager *_fileManager;
    NSString *_cachesDir;
    MBProgressHUD *_hud;
}

@property (nonatomic, copy) NSString *pwd;
@property (nonatomic) MDViewerController *viewerController;

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIBarButtonItem *loginButton;

- (IBAction)didPushButton:(id)sender;
- (IBAction)didPushRefreshItem:(id)sender;

@end
