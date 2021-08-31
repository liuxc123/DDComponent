//
//  DDAppDelegate.m
//  DDComponent
//
//  Created by liuxc123 on 08/30/2021.
//  Copyright (c) 2021 liuxc123. All rights reserved.
//

#import "DDAppDelegate.h"
#import <CatalogByConvention/CBCNodeListViewController.h>

@implementation DDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *rootViewController = [[CBCNodeListViewController alloc] initWithNode:CBCCreateNavigationTree()];
    rootViewController.title = @"Catalog by Convention";
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end
