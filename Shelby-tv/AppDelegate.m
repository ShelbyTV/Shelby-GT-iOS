//
//  AppDelegate.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// AppDelegate
#import "AppDelegate.h"

// Controllers
#import "TableViewManagers.h"
#import "StoryViewController.h"
#import "SettingsViewController.h"

// Analytics
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

- (void)createTabBarForPad;
- (void)createTabBarForPhone;
- (void)analytics;
- (void)customization;

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

#pragma mark - UIApplicationDelegate Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Instantiate UIWindow
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // UI Customization
    [self customization];
    
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
    TimelineTableViewManager *timelineTableViewManager = [[TimelineTableViewManager alloc] init];
    StoryViewController *timelineViewController = [[StoryViewController alloc] initWithType:StoryTypeTimeline andTableViewManager:timelineTableViewManager];
    [timelineViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [timelineViewController setTitle:@"Timeline"];
    
    // Create FavoritesViewController
    FavoritesTableViewManager *favoritesTableViewManager = [[FavoritesTableViewManager alloc] init];
    StoryViewController *favoritesViewController = [[StoryViewController alloc] initWithType:StoryTypeFavorites andTableViewManager:favoritesTableViewManager];
    [favoritesViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [favoritesViewController setTitle:@"Favorites"];
    
    // Create WatchLaterViewController
    WatchLaterTableViewManager *watchLaterTableViewManager = [[WatchLaterTableViewManager alloc] init];
    StoryViewController *watchLaterViewController = [[StoryViewController alloc] initWithType:StoryTypeWatchLater andTableViewManager:watchLaterTableViewManager];
    [watchLaterViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [watchLaterViewController setTitle:@"Watch Later"];
    
    // Create SearchViewController
    SearchTableViewManager *searchTableViewManager = [[SearchTableViewManager alloc] init];
    StoryViewController *searchViewController = [[StoryViewController alloc] initWithType:StoryTypeSearch andTableViewManager:searchTableViewManager];
    [searchViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [searchViewController setTitle:@"Search"];
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    [settingsViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [settingsViewController setTitle:@"Settings"];
    
    // Create UITabBarController
    self.tabBarController = [[UITabBarController alloc] init];
    NSArray *tabBarArray = [NSArray arrayWithObjects:timelineViewController, favoritesViewController, watchLaterViewController, searchViewController, settingsViewController, nil];
    self.tabBarController.viewControllers = tabBarArray;
    
    // Set tabBarController as window's rootViewController
    self.window.rootViewController = self.tabBarController;
    
}


#pragma mark - Private Methods
- (void)customization
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIBarStyleBlack];   
}

- (void)analytics
{
    // Crashlytics
    [Crashlytics startWithAPIKey:@"84a79b7ee6f2eca13877cd17b9b9a290790f99aa"];
}

@end