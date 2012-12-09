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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Loading...";
    hud.dimBackground = YES;
}

- (void)hideIndicator
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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
    DNSLog(@"Metadata loaded into path: %@", metadata.path);
    if (metadata.isDirectory) {
        for (DBMetadata *file in metadata.contents) {
            [_files addObject:file];
        }
        [self.tableView reloadData];
    }
    [self hideIndicator];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    DNSLog(@"Error loading metadata: %@", error);
    [self hideIndicator];
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
    [self.viewerController hideIndicator];
}

#pragma mark - MDLoginDelegate

- (void)didLogin
{
    [[self restClient] loadMetadata:self.pwd];
}

@end
