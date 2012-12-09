//
//  MDViewerController.h
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@class MDHTML;
@class MBProgressHUD;

@interface MDViewerController : UIViewController <DBRestClientDelegate>
{
    MDHTML *_html;
    NSString *_filePath;
    DBRestClient *_restClient;
    MBProgressHUD *_hud;
}

@property (nonatomic, copy) NSString *pwd;
@property (nonatomic) IBOutlet UIWebView *webView;

- (void)openFile:(NSString *)path;
- (void)showIndicator;
- (void)hideIndicator;
- (void)hideIndicatorWithErrorMessage;
- (IBAction)didPushRefreshItem:(id)sender;

@end
