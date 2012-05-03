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
    [streamViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"streamOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"streamOff"]];
    [streamViewController setTitle:@"Stream"];
    NSDictionary *streamDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Ubuntu-Bold" size:20.0f], UITextAttributeFont,
                                     [UIColor colorWithRed:98.0f/255.0f green:188.0f/255.0f blue:86.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [streamViewController.tabBarItem setTitleTextAttributes:streamDictionary forState:UIControlStateHighlighted];
    UINavigationController *streamNavigationController = [[UINavigationController alloc] initWithRootViewController:streamViewController];
    streamTableViewManager.navigationController = streamNavigationController;
    
    // Create RollsNavigationController
    RollsTableViewController *rollsTableViewController = [[RollsTableViewController alloc] initWithRollsType:RollsTypeYour];
    [rollsTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"rollsOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"rollsOff"]];
    [rollsTableViewController setTitle:@"Rolls"];
    NSDictionary *rollsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Ubuntu-Bold" size:0.0f], UITextAttributeFont,
                                     [UIColor colorWithRed:0.0f/255.0f green:146.0f/255.0f blue:193.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [rollsTableViewController.tabBarItem setTitleTextAttributes:rollsDictionary forState:UIControlStateHighlighted];
    UINavigationController *rollsNavigationController = [[UINavigationController alloc] initWithRootViewController:rollsTableViewController];
    rollsTableViewController.navigationController = rollsNavigationController;
    
    // Create SavesNavigationViewController
    SavesTableViewManager *savesTableViewManager = [[SavesTableViewManager alloc] init];
    GuideTableViewController *savesViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeSaves andTableViewManager:savesTableViewManager];
    [savesViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"savesOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"savesOff"]];
    [savesViewController setTitle:@"Saves"];
    NSDictionary *savesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Ubuntu-Bold" size:0.0f], UITextAttributeFont,
                                      [UIColor colorWithRed:141.0f/255.0f green:82.0f/255.0f blue:154.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [savesViewController.tabBarItem setTitleTextAttributes:savesDictionary forState:UIControlStateHighlighted];
    UINavigationController *savesNavigationController = [[UINavigationController alloc] initWithRootViewController:savesViewController];
    savesTableViewManager.navigationController = savesNavigationController;
    
    // Create SearchNavigationViewController
    SearchTableViewManager *searchTableViewManager = [[SearchTableViewManager alloc] init];
    GuideTableViewController *searchViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeSearch andTableViewManager:searchTableViewManager];
    [searchViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"searchOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"searchOff"]];
    NSDictionary *searchDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Ubuntu-Bold" size:0.0f], UITextAttributeFont,
                                      [UIColor colorWithRed:227.0f/255.0f green:59.0f/255.0f blue:46.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [searchViewController.tabBarItem setTitleTextAttributes:searchDictionary forState:UIControlStateHighlighted];
    [searchViewController setTitle:@"Search"];
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchTableViewManager.navigationController = searchNavigationController;
    
    YouTableViewController *youTableViewController = [[YouTableViewController alloc] init];
    [youTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"youOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"youOff"]];
    [youTableViewController setTitle:@"You"];
    NSDictionary *youDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont fontWithName:@"Ubuntu-Bold" size:0.0f], UITextAttributeFont,
                                   [UIColor colorWithRed:239.0f/255.0f green:232.0f/255.0f blue:75.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [youTableViewController.tabBarItem setTitleTextAttributes:youDictionary forState:UIControlStateHighlighted];
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
    // UIStatusBar 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // UINavigationBar
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1.0f]];
    
    // UIBarButtonItem
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:70.f/255.0f green:70.f/255.0f blue:70.f/255.0f alpha:1.0f]];

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