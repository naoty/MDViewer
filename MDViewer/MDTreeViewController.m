//
//  MDTreeViewController.m
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDTreeViewController.h"
#import "MBProgressHUD.h"
#import "MDAppDelegate.h"
#import "MDViewerController.h"
#import "NSString+Filetype.h"

@interface MDTreeViewController ()

@end

@implementation MDTreeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MDAppDelegate *appDelegate = (MDAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.loginDelegate = self;
    
    if (self.pwd == nil) {
        self.pwd = @"/";
    }
    if (self.title == nil) {
        self.title = @"/";
    }
    
    _files = [NSMutableArray array];
    _fileManager = [NSFileManager defaultManager];
    _cachesDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    if ([[DBSession sharedSession] isLinked]) {
        DNSLog(@"Loading metadata...");
        [self showIndicator];
        [[self restClient] loadMetadata:self.pwd];
        self.loginButton.title = @"Logout";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DBRestClient *)restClient
{
    if (!_restClient) {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    return _restClient;
}

- (IBAction)didPushButton:(id)sender
{
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        
        self.loginButton.title = @"Logout";
    } else {
        [[DBSession sharedSession] unlinkAll];
        
        [_files removeAllObjects];
        [self.tableView reloadData];
        [self.viewerController closeFile];

        self.loginButton.title = @"Login";
    }
}

- (IBAction)didPushRefreshItem:(id)sender
{
    if ([[DBSession sharedSession] isLinked]) {
        [self showIndicator];
        [[self restClient] loadMetadata:self.pwd];
    }
}

- (void)showIndicator
{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Loading...";
    _hud.dimBackground = YES;
}

- (void)hideIndicator
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)hideIndicatorWithErrorMessage
{
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"Loading Error";
    [_hud hide:YES afterDelay:1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DBMetadata *file = _files[indexPath.row];
    cell.textLabel.text = file.filename;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Download to Cache
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *filePath = [_cachesDir stringByAppendingPathComponent:cell.textLabel.text];
    
    DBMetadata *file = _files[indexPath.row];
    
    if (file.isDirectory) {
        MDTreeViewController *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"MDTreeViewController"];
        childController.pwd = file.path;
        childController.title = file.filename;
        childController.viewerController = self.viewerController;
        [self.navigationController pushViewController:childController animated:YES];
        
        return;
    }
    
    self.viewerController.pwd = file.path;
    
    if ([_fileManager fileExistsAtPath:filePath]) {
        [self.viewerController openFile:filePath];
    } else {
        DNSLog(@"Loading %@ ...", file.path);
        [self.viewerController showIndicator];
        [[self restClient] loadFile:file.path intoPath:filePath];
    }
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    [_files removeAllObjects];
    
    DNSLog(@"Metadata loaded into path: %@", metadata.path);
    if (metadata.isDirectory) {
        for (DBMetadata *file in metadata.contents) {
            // List only directory, markdown or css
            if (file.isDirectory || file.path.isMarkdown || file.path.isCSS) {
                [_files addObject:file];
            }
        }
        [self.tableView reloadData];
    }
    [self hideIndicator];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    DNSLog(@"Error loading metadata: %@", error);
    [self hideIndicatorWithErrorMessage];
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
    DNSLog(@"File loaded into path: %@", destPath);
    [self.viewerController openFile:destPath];
    [self.viewerController hideIndicator];
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    DNSLog(@"There was an error loading file - %@", error);
    [self.viewerController hideIndicatorWithErrorMessage];
}

#pragma mark - MDLoginDelegate

- (void)didLogin
{
    [[self restClient] loadMetadata:self.pwd];
}

@end
