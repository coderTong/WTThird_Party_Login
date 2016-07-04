//
//  AppDelegate.m
//  WTThird_Party_Login
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "AppDelegate.h"
#import "WTThirdPartyLoginManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
// iOS9 以上用这个方法接收
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSDictionary * dic = options;
    NSLog(@"%@", dic);
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.sina.weibo"]) {
        NSLog(@"新浪微博~");
        
        return [WeiboSDK handleOpenURL:url delegate:[WTThirdPartyLoginManager shareWTThirdPartyLoginManager]];
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]){
        
        return [WXApi handleOpenURL:url delegate:[WTThirdPartyLoginManager shareWTThirdPartyLoginManager]];
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"]){
        
        //        [WTThirdPartyLoginManager didReceiveTencentUrl:url];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}
// iOS9 以下用这个方法接收
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@",url);
    
    
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        
        return [WeiboSDK handleOpenURL:url delegate:[WTThirdPartyLoginManager shareWTThirdPartyLoginManager]];
        
    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]){
        
        return [WXApi handleOpenURL:url delegate:[WTThirdPartyLoginManager shareWTThirdPartyLoginManager]];
        
    }else if ([sourceApplication isEqualToString:@"com.tencent.mqq"]){
        
        //        [WTShareManager didReceiveTencentUrl:url];
        return [TencentOAuth HandleOpenURL:url];
    }
    
    
    return YES;
}
@end
