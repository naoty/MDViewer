//
//  MDViewerController.m
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDViewerController.h"
#import "GHMarkdownParser.h"

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openMarkdown:(NSString *)path
{
    NSError *error = nil;
    NSString *markdown = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSString *html = markdown.flavoredHTMLStringFromMarkdown;
    
    [self.webView loadHTMLString:html baseURL:nil];
}

@end
