//
//  AppDelegate.m
//  Shelby-tv
//
//  Created by Arthur on 4/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// AppDelegate
#import "AppDelegate.h"

// Controllers
#import "TimelineViewController.h"
#import "FavoritesViewController.h"
#import "WatchLaterViewController.h"
#import "SearchViewController.h"

// Analytics
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

- (void)createTabBarForPad;
- (void)createTabBarForPhone;
- (void)analytics;

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

#pragma mark - UIApplicationDelegate Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Instantiate UIWindow
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Add Analytics
    [self analytics];
    
    // Create Navigation Architecture for iPhone and iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self createTabBarForPhone];
    } else {
        [self createTabBarForPad];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - UITabBarController Creation Methods
- (void)createTabBarForPad
{
}

- (void)createTabBarForPhone
{
    TimelineViewController *timelineViewController = [[TimelineViewController alloc] initWithNibName:@"TimelineViewController" bundle:nil];
    [timelineViewController setTitle:@"Timeline"];
    
    FavoritesViewController *favoritesViewController = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
    [favoritesViewController setTitle:@"Favorites"];
    
    WatchLaterViewController *watchLaterViewController = [[WatchLaterViewController alloc] initWithNibName:@"WatchLaterViewController" bundle:nil];
    [watchLaterViewController setTitle:@"Watch Later"];
    
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [searchViewController setTitle:@"Search"];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    NSArray *tabBarArray = [NSArray arrayWithObjects:timelineViewController, favoritesViewController, watchLaterViewController, searchViewController, nil];
    self.tabBarController.viewControllers = tabBarArray;
    
    self.window.rootViewController = self.tabBarController;
    
}

#pragma mark - Analytics Methods
- (void)analytics
{
    // Crashlytics
    [Crashlytics startWithAPIKey:@"84a79b7ee6f2eca13877cd17b9b9a290790f99aa"];
}

@end