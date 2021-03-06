//
//  OCAppDelegate.m
//  OnlineConfig
//
//  Created by binbins on 03/13/2017.
//  Copyright (c) 2017 binbins. All rights reserved.
//




#import "OCAppDelegate.h"
@import OnlineConfig;

@implementation OCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ConfigRequest updateRemoteConfig];
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
    [ConfigRequest updateRemoteConfig];
    NSDictionary *appkey = [ConfigRequest dictionaryForKey:@"appkey"];
    NSArray *native = [ConfigRequest arrayForKey:@"pos_native"];
    BOOL isreviewing = [ConfigRequest boolForKey:@"a_taolu_enable"];
    NSArray *wrongArr = [ConfigRequest arrayForKey:@"other"];
    NSLog(@"appkey:%@ , native:%@, a_taolu_enable:%d, wrongarr:%@", appkey, native, (int)isreviewing, wrongArr);
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@""]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
