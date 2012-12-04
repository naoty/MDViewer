//
//  MDTreeViewController.m
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDTreeViewController.h"
#import "MDAppDelegate.h"

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
    
    _fileNames = [NSMutableArray array];
    
    if ([[DBSession sharedSession] isLinked]) {
        [self loginWithDropbox];
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
        [_fileNames removeAllObjects];
        [self.tableView reloadData];

        self.loginButton.title = @"Login";
    }
}

- (void)loginWithDropbox
{
    [[self restClient] loadMetadata:@"/"];
    self.loginButton.title = @"Logout";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fileNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _fileNames[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    if (metadata.isDirectory) {
        DNSLog(@"Directory '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            DNSLog(@"\t%@", file.filename);
            
            [_fileNames addObject:file.filename];
        }
        [self.tableView reloadData];
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    DNSLog(@"Error loading metadata: %@", error);
}

@end
