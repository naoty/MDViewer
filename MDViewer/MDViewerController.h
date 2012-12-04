//
//  MDViewerController.h
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDViewerController : UIViewController

@property (nonatomic) IBOutlet UIWebView *webView;

- (void)openMarkdown:(NSString *)path;

@end
