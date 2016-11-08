//
//  AppDelegate.m
//  BaiduMapTest
//
//  Created by 李保东 on 16/11/8.
//  Copyright © 2016年 李保东. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import "BMKMainListViewController.h"


@interface AppDelegate ()
@property(nonatomic,strong)UINavigationController *navigationController;
@property(nonatomic,strong)BMKMapManager *mapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {       // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"kxTaFNBjizmZwgkAsLC21i2NR1jvZ7tZ"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    self.window.frame =[UIScreen mainScreen].bounds;
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:[[BMKMainListViewController alloc] init]];
    self.window.rootViewController =nav;
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError {
    if (iError) {
        NSLog(@"error =%d",iError);
        mAlertView(@"提示", @"联网失败");

    }else {
        NSLog(@"联网成功");
    }
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError {

    if (iError) {
        mAlertView(@"提示", @"授权失败");
        NSLog(@"error =%d",iError);
    }else {
        mAlertView(@"提示", @"授权成功");
        NSLog(@"授权成功");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
