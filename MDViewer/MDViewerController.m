//
//  MDViewerController.m
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDViewerController.h"
#import "GHMarkdownParser.h"
#import "MBProgressHUD.h"
#import "NSString+Filetype.h"
#import "MDHTML.h"

@interface MDViewerController ()

@end

@implementation MDViewerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _html = [[MDHTML alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openFile:(NSString *)file
{
    _filePath = file;
    
    NSError *error = nil;
    NSString *fileString = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    
    if ([file isMarkdown]) {
        _html.body = fileString.flavoredHTMLStringFromMarkdown;
    } else if ([file isCSS]) {
        _html.style = fileString;
    }
    
    [self.webView loadHTMLString:[_html stringify] baseURL:nil];
}

- (void)showIndicator
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.dimBackground = YES;
}

- (void)hideIndicator
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)didPushRefreshItem:(id)sender
{
    if (self.pwd == nil) {
        return;
    }
    
    if ([[DBSession sharedSession] isLinked]) {
        DNSLog(@"Loading file...");
        [self showIndicator];
        [[self restClient] loadFile:self.pwd intoPath:_filePath];
    }
}

- (DBRestClient *)restClient
{
    if (!_restClient) {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    return _restClient;
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
    DNSLog(@"Loaded file: %@", destPath);
    [self openFile:destPath];
    [self hideIndicator];
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    DNSLog(@"Error: %@", error);
    [self hideIndicator];
}

@end
