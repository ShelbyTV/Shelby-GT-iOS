//
//  AppDelegate.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// AppDelegate
#import "AppDelegate.h"

// Models
#import "SocialFacade.h"

// Controllers
#import "TableViewManagers.h"
#import "YouTableViewController.h"
#import "StoryViewController.h"
#import "LoginViewController.h"

// Analytics
#import <Crashlytics/Crashlytics.h>

// Constants 
#import "Constants.h"

@interface AppDelegate ()

- (void)analytics;
- (void)customization;
- (void)createRootViewForPad;
- (void)createRootViewForPhone;
- (void)presentLoginViewController;

@end

@implementation AppDelegate
@synthesize window = _window;

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
        [self createRootViewForPhone];
    } else {
        [self createRootViewForPad];
    }
    
    // Make RootViewController Visible
    [self.window makeKeyAndVisible];

    // Present LoginViewController for Proper Device, which performs authorization status check
    [self presentLoginViewController];
    
    return YES;
}

#pragma mark - Creation Methods
- (void)createRootViewForPad
{
    
}

- (void)createRootViewForPhone
{
    // Create TimelineViewController
    StreamTableViewManager *streamTableViewManager = [[StreamTableViewManager alloc] init];
    StoryViewController *streamViewController = [[StoryViewController alloc] initWithType:StoryTypeStream andTableViewManager:streamTableViewManager];
    [streamViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [streamViewController setTitle:@"Stream"];
    
    // Create FavoritesViewController
    YourRollsTableViewManager *yourRollsTableViewManager = [[YourRollsTableViewManager alloc] init];
    StoryViewController *yourRollsViewController = [[StoryViewController alloc] initWithType:StoryTypeRolls andTableViewManager:yourRollsTableViewManager];
    [yourRollsViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [yourRollsViewController setTitle:@"Rolls"];
    
    // Create WatchLaterViewController
    SaveTableViewManager *saveTableViewManager = [[SaveTableViewManager alloc] init];
    StoryViewController *saveViewController = [[StoryViewController alloc] initWithType:StoryTypeSave andTableViewManager:saveTableViewManager];
    [saveViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [saveViewController setTitle:@"Save"];
    
    // Create SearchViewController
    SearchTableViewManager *searchTableViewManager = [[SearchTableViewManager alloc] init];
    StoryViewController *searchViewController = [[StoryViewController alloc] initWithType:StoryTypeSearch andTableViewManager:searchTableViewManager];
    [searchViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [searchViewController setTitle:@"Search"];
    
    YouTableViewController *youTableViewController = [[YouTableViewController alloc] init];
    [youTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [youTableViewController setTitle:@"You"];
    
    // Create UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray *tabBarArray = [NSArray arrayWithObjects:streamViewController, yourRollsViewController, saveViewController, searchViewController, youTableViewController, nil];
    tabBarController.viewControllers = tabBarArray;

    // Create UINavigationController and navigationBar
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    [navigationController setNavigationBarHidden:YES];
    
    // Set navigationController as window's rootViewController
    self.window.rootViewController = navigationController;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kArchitecturalElementsReferenceDictionary object:tabBarController]; 
    
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

- (void)presentLoginViewController
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPhone" bundle:nil];
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
        
    } else {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
        
    }
}

@end