//
//  OCAppDelegate.m
//  OnlineConfig
//
//  Created by binbins on 03/13/2017.
//  Copyright (c) 2017 binbins. All rights reserved.
//

#define CONFIGURL @"http://service.kv.dandanjiang.tv/online/params?apppackagename=com.zhangqinwan.wp&appversioncode=3&appversionname=1.1&package_name=com.zhangqinwan.wp&platform=ios&sys_language=zh-Hans-CN&sys_model=iPhone&sys_name=iOS&sys_ver=10.2.2"
#define testurl @"http://192.168.0.217:9100/"

#import "OCAppDelegate.h"
@import OnlineConfig;

@implementation OCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ConfigRequest updateConfig:CONFIGURL];
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
    [ConfigRequest updateConfig:testurl];
    NSDictionary *appkey = [ConfigRequest dictionaryForKey:@"appkey"];
    NSArray *native = [ConfigRequest arrayForKey:@"pos_native"];
    BOOL isreviewing = [ConfigRequest boolForKey:@"isreviewing"];
    NSArray *wrongArr = [ConfigRequest arrayForKey:@"other"];
    NSLog(@"appkey:%@ , native:%@, isreviewing:%d, wrongarr:%@", appkey, native, (int)isreviewing, wrongArr);
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

@end