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
    
    _html = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openFile:(NSString *)file
{
    if ([file isMarkdown]) {
        NSError *error = nil;
        NSString *markdown = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
        _html = markdown.flavoredHTMLStringFromMarkdown;
        
        [self.webView loadHTMLString:_html baseURL:nil];
    }
    
    else if ([file isCSS]) {
        DNSLog(@"This filetype is css");
    }
}

@end
