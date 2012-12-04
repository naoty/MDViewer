//
//  MDAppDelegate.h
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MDAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) NSString *dbAppKey;
@property (nonatomic) NSString *dbAppSecret;
@property (nonatomic) NSString *dbRoot;

@end
