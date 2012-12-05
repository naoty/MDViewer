//
//  MDViewerController.m
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDViewerController.h"
#import "GHMarkdownParser.h"
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
    NSError *error = nil;
    NSString *fileString = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    
    if ([file isMarkdown]) {
        _html.body = fileString.flavoredHTMLStringFromMarkdown;
    } else if ([file isCSS]) {
        _html.style = fileString;
    }
    
    [self.webView loadHTMLString:[_html stringify] baseURL:nil];
}

@end
