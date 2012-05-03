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
#import "GuideTableViewController.h"
#import "RollsTableViewController.h"
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return ( [[[SocialFacade sharedInstance] facebook] handleOpenURL:url] ) ? YES : NO;
}

#pragma mark - Creation Methods
- (void)createRootViewForPad
{
    
}

- (void)createRootViewForPhone
{

    // Create StreamNavigationController
    StreamTableViewManager *streamTableViewManager = [[StreamTableViewManager alloc] init];
    GuideTableViewController *streamViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeStream andTableViewManager:streamTableViewManager];
    [streamViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [streamViewController setTitle:@"Stream"];
    UINavigationController *streamNavigationController = [[UINavigationController alloc] initWithRootViewController:streamViewController];
    streamTableViewManager.navigationController = streamNavigationController;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:nil];
    [streamViewController.navigationItem setRightBarButtonItem:barButton];
    
    // Create RollsNavigationController
    RollsTableViewController *rollsTableViewController = [[RollsTableViewController alloc] initWithRollsType:RollsTypeYour];
    [rollsTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [rollsTableViewController setTitle:@"Rolls"];
    UINavigationController *rollsNavigationController = [[UINavigationController alloc] initWithRootViewController:rollsTableViewController];
    rollsTableViewController.navigationController = rollsNavigationController;
    
    // Create SavesNavigationViewController
    SavesTableViewManager *savesTableViewManager = [[SavesTableViewManager alloc] init];
    GuideTableViewController *savesViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeSaves andTableViewManager:savesTableViewManager];
    [savesViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [savesViewController setTitle:@"Saves"];
    UINavigationController *savesNavigationController = [[UINavigationController alloc] initWithRootViewController:savesViewController];
    savesTableViewManager.navigationController = savesNavigationController;
    
    // Create SearchNavigationViewController
    SearchTableViewManager *searchTableViewManager = [[SearchTableViewManager alloc] init];
    GuideTableViewController *searchViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeSearch andTableViewManager:searchTableViewManager];
    [searchViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [searchViewController setTitle:@"Search"];
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchTableViewManager.navigationController = searchNavigationController;
    
    YouTableViewController *youTableViewController = [[YouTableViewController alloc] init];
    [youTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@""] withFinishedUnselectedImage:[UIImage imageNamed:@""]];
    [youTableViewController setTitle:@"You"];
    UINavigationController *youNavigationController = [[UINavigationController alloc] initWithRootViewController:youTableViewController];
    youTableViewController.navigationController = youNavigationController;
    
    // Create UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSArray *tabBarArrayOfNavigationControllers = [NSArray arrayWithObjects:streamNavigationController, rollsNavigationController, savesNavigationController, searchNavigationController, youNavigationController, nil];
    
    tabBarController.viewControllers = tabBarArrayOfNavigationControllers;
    
    // Set navigationController as window's rootViewController
    self.window.rootViewController = tabBarController;
    
}

#pragma mark - Private Methods
- (void)customization
{ 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
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