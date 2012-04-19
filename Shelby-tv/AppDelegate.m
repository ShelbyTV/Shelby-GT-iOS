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
#import "StoryViewController.h"

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
    // Create TimelineViewController
    StoryViewController *timelineViewController = [[StoryViewController alloc] init];
    [timelineViewController.tabBarItem setImage:[UIImage imageNamed:@"tabBarButtonTimelineNormal"]];
    [timelineViewController setTitle:@"Timeline"];
    
    // Create FavoritesViewController
    StoryViewController *favoritesViewController = [[StoryViewController alloc] init];
    [timelineViewController.tabBarItem setImage:[UIImage imageNamed:@"tabBarButtonFavoritesNormal"]];
    [favoritesViewController setTitle:@"Favorites"];
    
    // Create WatchLaterViewController
    StoryViewController *watchLaterViewController = [[StoryViewController alloc] init];
    [timelineViewController.tabBarItem setImage:[UIImage imageNamed:@"tabBarButtonWatchLaterNormal"]];
    [watchLaterViewController setTitle:@"Watch Later"];
    
    // Create SearchViewController
    StoryViewController *searchViewController = [[StoryViewController alloc] init];
    [searchViewController setTitle:@"Search"];
    
    // Create UITabBarController
    self.tabBarController = [[UITabBarController alloc] init];
    NSArray *tabBarArray = [NSArray arrayWithObjects:timelineViewController, favoritesViewController, watchLaterViewController, searchViewController, nil];
    self.tabBarController.viewControllers = tabBarArray;
    
    // Set tabBarController as window's rootViewController
    self.window.rootViewController = self.tabBarController;
    
}

#pragma mark - Analytics Methods
- (void)analytics
{
    // Crashlytics
    [Crashlytics startWithAPIKey:@"84a79b7ee6f2eca13877cd17b9b9a290790f99aa"];
}

@end