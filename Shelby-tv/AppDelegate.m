//
//  AppDelegate.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 4/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// AppDelegate
#import "AppDelegate.h"

// Analytics
#import <Crashlytics/Crashlytics.h>

// ViewControllers
#import "ShelbyMenuViewController.h"
#import "LoginViewController.h"
#import "GuideTableViewController.h"
#import "SettingsTableViewController.h"

// Controllers
#import "SocialFacade.h"

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
@synthesize progressHUD = _progressHUD;

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
    
    GuideTableViewController *exploreRollsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_ExploreRolls];
    UINavigationController *exploreRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:exploreRollsTableViewController];
    exploreRollsTableViewController.navigationController = exploreRollsNavigationController;
    [viewControllers setValue:exploreRollsNavigationController forKey:TextConstants_Section_ExploreRolls];
    
    GuideTableViewController *friendsRollsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_FriendsRolls];
    UINavigationController *friendsRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:friendsRollsTableViewController];
    friendsRollsTableViewController.navigationController = friendsRollsNavigationController;
    [viewControllers setValue:friendsRollsNavigationController forKey:TextConstants_Section_FriendsRolls];
    
    GuideTableViewController *myRollsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_MyRolls];
    UINavigationController *myRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:myRollsTableViewController];
    myRollsTableViewController.navigationController = myRollsNavigationController;
    [viewControllers setValue:myRollsNavigationController forKey:TextConstants_Section_MyRolls];
    
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
    exploreRollsTableViewController.menuController = self.menuController;
    friendsRollsTableViewController.menuController = self.menuController;
    myRollsTableViewController.menuController = self.menuController;
    settingsTableViewController.menuController = self.menuController;
    streamTableViewController.menuController = self.menuController;
    
    self.window.rootViewController = self.menuController;
    
}

#pragma mark - Public Methods
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

- (void)addHUDWithMessage:(NSString *)message
{
    [self removeHUD];
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [UIFont fontWithName:@"Ubuntu-Bold" size:12.0f];
    
}

- (void)removeHUD
{
    // If an older progressHUD is working, remove it to make room for the new HUD
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    
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

@end