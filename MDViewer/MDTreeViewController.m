//
//  MDTreeViewController.m
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDTreeViewController.h"
#import "MDAppDelegate.h"
#import "MDViewerController.h"

@interface MDTreeViewController ()

@end

@implementation MDTreeViewController

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
    
    MDAppDelegate *appDelegate = (MDAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.loginDelegate = self;
    
    _files = [NSMutableArray array];
    _fileManager = [NSFileManager defaultManager];
    _cachesDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    if ([[DBSession sharedSession] isLinked]) {
        [[self restClient] loadMetadata:@"/"];
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
    
    if ([_fileManager fileExistsAtPath:filePath]) {
        DNSLog(@"File exists: %@", filePath);
        [self.viewerController openMarkdown:filePath];
    } else {
        DNSLog(@"File doesn't exist: %@", filePath);
        
        DBMetadata *file = _files[indexPath.row];
        [[self restClient] loadFile:file.path intoPath:filePath];
    }
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    if (metadata.isDirectory) {
        DNSLog(@"Directory '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            DNSLog(@"\t%@", file.filename);
            
            [_files addObject:file];
        }
        [self.tableView reloadData];
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    DNSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
    DNSLog(@"File loaded into path: %@", destPath);
    [self.viewerController openMarkdown:destPath];
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    DNSLog(@"There was an error loading file - %@", error);
}

#pragma mark - MDLoginDelegate

- (void)didLogin
{
    [[self restClient] loadMetadata:@"/"];
}

@end
