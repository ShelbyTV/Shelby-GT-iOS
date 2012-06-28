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

// Analytics
#import <Crashlytics/Crashlytics.h>

// Controllers
#import "GuideTableViewController.h"
#import "LoginViewController.h"

#import "SettingsTableViewController.h"
#import "ShelbyMenuViewController.h"

// Core Data
#import <CoreData/CoreData.h>
#import "CoreDataUtility.h"

@interface AppDelegate ()

@property (strong, nonatomic) ShelbyMenuViewController *menuController;

- (void)analytics;
- (void)customization;
- (void)createRootView;

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize menuController = _menuController;

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
    [self createRootView];
 
    // Make RootViewController Visible
    [self.window makeKeyAndVisible];

    // Present LoginViewController for Proper Device if Shelby isn't authorized
   if ( ![[SocialFacade sharedInstance] shelbyAuthorized] ) [self presentLoginViewController];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[[SocialFacade sharedInstance] facebook] handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save changes to managedObjectContext before shutdown.
    [CoreDataUtility saveContext:[CoreDataUtility sharedInstance].managedObjectContext];
}

#pragma mark - Creation Methods
- (void)createRootView
{
    
    NSMutableDictionary *viewControllers = [NSMutableDictionary dictionary];
    
    GuideTableViewController *browseRollsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_BrowseRolls];
    UINavigationController *browseRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:browseRollsTableViewController];
    browseRollsTableViewController.navigationController = browseRollsNavigationController;
    [viewControllers setValue:browseRollsNavigationController forKey:TextConstants_Section_BrowseRolls];
    
    GuideTableViewController *myRollsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_MyRolls];
    UINavigationController *myRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:myRollsTableViewController];
    myRollsTableViewController.navigationController = myRollsNavigationController;
    [viewControllers setValue:myRollsNavigationController forKey:TextConstants_Section_MyRolls];
    
    GuideTableViewController *peopleRollsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_PeopleRolls];
    UINavigationController *peopleRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:peopleRollsTableViewController];
    peopleRollsTableViewController.navigationController = peopleRollsNavigationController;
    [viewControllers setValue:peopleRollsNavigationController forKey:TextConstants_Section_PeopleRolls];
    
    SettingsTableViewController *settingsTableViewController = [[SettingsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsTableViewController];
    settingsTableViewController.navigationController = settingsNavigationController;
    [viewControllers setValue:settingsNavigationController forKey:TextConstants_Section_Settings];
    
    GuideTableViewController *streamTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_Stream];
    UINavigationController *streamNavigationController = [[UINavigationController alloc] initWithRootViewController:streamTableViewController];
    streamTableViewController.navigationController = streamNavigationController;
    [viewControllers setValue:streamNavigationController forKey:TextConstants_Section_Stream];

    self.menuController = [[ShelbyMenuViewController alloc] initWithViewControllers:viewControllers];
    
    // Add reference to ShelbyMenuViewController
    browseRollsTableViewController.menuController = self.menuController;
    myRollsTableViewController.menuController = self.menuController;
    peopleRollsTableViewController.menuController = self.menuController;
    settingsTableViewController.menuController = self.menuController;
    streamTableViewController.menuController = self.menuController;
    
    self.window.rootViewController = self.menuController;
    
}

#pragma mark - Private Methods
- (void)customization
{ 
    // UIStatusBar 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];

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
        loginViewController.menuController = self.menuController;
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
        [[SocialFacade sharedInstance] setLoginViewController:loginViewController];
        
    } else {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
        loginViewController.menuController = self.menuController;
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
        [[SocialFacade sharedInstance] setLoginViewController:loginViewController];
    }
}

@end