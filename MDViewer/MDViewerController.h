//
//  MDViewerController.h
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDHTML;

@interface MDViewerController : UIViewController
{
    MDHTML *_html;
}

@property (nonatomic) IBOutlet UIWebView *webView;

- (void)openFile:(NSString *)path;
- (void)showProgress;
- (void)hideProgress;

@end
