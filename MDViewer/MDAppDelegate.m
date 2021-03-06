//
//  MDAppDelegate.m
//  MDViewer
//
//  Created by naoty on 2012/12/03.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDAppDelegate.h"
#import "MDTreeViewController.h"
#import "MDViewerController.h"
#import "TestFlight.h"

@implementation MDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Secrets" ofType:@"plist"];
    NSDictionary *secrets = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // TestFlight SDK
    [TestFlight takeOff:secrets[@"TestFlight"][@"AppToken"]];
    
    // Dropbox iOS SDK
    NSString *appKey = secrets[@"Dropbox"][@"AppKey"];
    NSString *appSecret = secrets[@"Dropbox"][@"AppSecret"];
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:kDBRootAppFolder];
    [DBSession setSharedSession:dbSession];
    
    // Controllers
    UISplitViewController *splitViewController = (UISplitViewController *) self.window.rootViewController;
    MDTreeViewController *treeViewController = (MDTreeViewController *) [splitViewController.viewControllers[0] topViewController];
    MDViewerController *viewerController = (MDViewerController *) [splitViewController.viewControllers lastObject];
    treeViewController.viewerController = viewerController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            DNSLog(@"App linked successfully!");
            [self.loginDelegate didLogin];
        }
        return YES;
    }
    return NO;
}

@end
