//
//  MDTreeViewController.h
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MDTreeViewController : UITableViewController <DBRestClientDelegate>
{
    DBRestClient *_restClient;
    NSMutableArray *_fileNames;
}

@property (nonatomic) IBOutlet UITableView *tableView;

@end
