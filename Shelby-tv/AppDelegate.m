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
#import "GuideViewController.h"
#import "RollsViewController.h"
#import "LoginViewController.h"
#import "YouTableViewController.h"

// Analytics
#import <Crashlytics/Crashlytics.h>

// Constants 
#import "StaticDeclarations.h"

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
    GuideViewController *streamViewController = [[GuideViewController alloc] initWithGuideType:GuideTypeStream andTableViewManager:streamTableViewManager];
    [streamViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [streamViewController setTitle:@"Stream"];
    
    // Create FavoritesViewController
    RollsViewController *rollsViewController = [[RollsViewController alloc] initWithNibName:@"RollsViewController" bundle:nil];
    [rollsViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [rollsViewController setRollsType:RollsTypeYour];
    [rollsViewController setTitle:@"Rolls"];
    
    // Create WatchLaterViewController
    SavesTableViewManager *savesTableViewManager = [[SavesTableViewManager alloc] init];
    GuideViewController *savesViewController = [[GuideViewController alloc] initWithGuideType:GuideTypeSaves andTableViewManager:savesTableViewManager];
    [savesViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [savesViewController setTitle:@"Save"];
    
    // Create SearchViewController
    SearchTableViewManager *searchTableViewManager = [[SearchTableViewManager alloc] init];
    GuideViewController *searchViewController = [[GuideViewController alloc] initWithGuideType:GuideTypeSearch andTableViewManager:searchTableViewManager];
    [searchViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [searchViewController setTitle:@"Search"];
    
    YouTableViewController *youTableViewController = [[YouTableViewController alloc] init];
    [youTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [youTableViewController setTitle:@"You"];
    
    // Create UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray *tabBarArray = [NSArray arrayWithObjects:streamViewController, rollsViewController, savesViewController, searchViewController, youTableViewController, nil];
    tabBarController.viewControllers = tabBarArray;

    // Create UINavigationController and navigationBar
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    // Set navigationController as window's rootViewController
    self.window.rootViewController = navigationController;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kArchitecturalElementsReferenceDictionary object:tabBarController]; 
    
}

#pragma mark - Private Methods
- (void)customization
{
//     [[UIApplication sharedApplication] setStatusBarStyle:UIBarStyleBlack];   
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
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