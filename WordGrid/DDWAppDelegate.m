//
//  DDWAppDelegate.m
//  WordGrid
//
//  Created by admin on 11-12-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DDWAppDelegate.h"
#import "GameViewController.h"
#import "Game.h"
//#import <AVFoundation/AVAudioSession.h>

SystemSoundID correctWordSoundID;
SystemSoundID errorSoundID;
SystemSoundID returnWordsSoundID;
SystemSoundID winSoundID;
SystemSoundID tickSoundID;

@implementation DDWAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    UINavigationController *nc = (UINavigationController *)self.window.rootViewController;
    if(nc.topViewController.class == GameViewController.class)
    {
        [[Game instance] saveRound];
    }
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
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UINavigationController *nc = (UINavigationController *)self.window.rootViewController;
    if(nc.topViewController.class == GameViewController.class)
    {
        [[Game instance] saveRound];
    }
}

@end
