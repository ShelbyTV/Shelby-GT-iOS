//
//  AppDelegate.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 4/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "AppDelegate.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>
#import <Crashlytics/Crashlytics.h>

// Controllers
#import "SocialFacade.h"
#import "CoreDataUtility.h"

// View Controllers
#import "LoginViewController.h"
#import "GuideTableViewController.h"
#import "SettingsTableViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIView *progressView;

- (void)analytics;
- (void)customization;
- (void)createRootView;
- (void)createProgressView;

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize menuController = _menuController;
@synthesize progressView = _progressView;
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save changes to managedObjectContext before shutdown.
    [CoreDataUtility saveContext:[CoreDataUtility sharedInstance].managedObjectContext];
}

#pragma mark - Creation Methods
- (void)createRootView
{
    
    // Create list of viewControllers
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
    
    // Create invisible navigationController (used for pushing CommentVC, RollItVC, and ShareVC)
    UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:self.menuController];
    self.menuController.navigationController = menuNavigationController;
    [menuNavigationController setNavigationBarHidden:YES];
 
    // Set rootViewController
    self.window.rootViewController = menuNavigationController;
    
}

#pragma mark - Public Methods
- (void)presentLoginViewController
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPhone" bundle:nil];
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
        [[SocialFacade sharedInstance] setLoginViewController:loginViewController];
        
    } else {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
        [[SocialFacade sharedInstance] setLoginViewController:loginViewController];
    }
}

- (void)addHUDWithMessage:(NSString *)message
{
    // Remove HUD (if it exists)
    [self removeHUD];
    
    // Create new view to hold HUD in window
    [self createProgressView];
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.progressView animated:YES];
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [UIFont fontWithName:@"Ubuntu-Bold" size:12.0f];

}

- (void)removeHUD
{
    // If an older progressHUD exists, remove it to make room for the new HUD
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    [self.progressView removeFromSuperview];
    
}

#pragma mark - Private Methods
- (void)customization
{ 
    // UIStatusBar 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)createProgressView
{
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 350.0f, 320.0f, 70.0f)];
    [self.window addSubview:self.progressView];
}

- (void)analytics
{
    // Crashlytics
    [Crashlytics startWithAPIKey:@"84a79b7ee6f2eca13877cd17b9b9a290790f99aa"];
}

@end