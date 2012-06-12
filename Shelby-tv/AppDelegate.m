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
#import "LoginViewController.h"

// Analytics
#import <Crashlytics/Crashlytics.h>

// Constants 
#import "StaticDeclarations.h"

// Core Data
#import <CoreData/CoreData.h>
#import "CoreDataUtility.h"

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

    // Present LoginViewController for Proper Device if Shelby isn't authorized
   if ( ![[SocialFacade sharedInstance] shelbyAuthorized] ) [self presentLoginViewController];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[[SocialFacade sharedInstance] facebook] handleOpenURL:url];
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    // Save changes to managedObjectContext before shutdown.
    if ( DEBUGMODE ) NSLog(@"Saving updates to Core Data before Shutdown");
    [CoreDataUtility saveContext:[CoreDataUtility sharedInstance].managedObjectContext];
}

#pragma mark - Creation Methods
- (void)createRootViewForPad
{
    
}

- (void)createRootViewForPhone
{
    
    ///* STREAM *///
    
    // Create streamNavigationController, and initialize it with streamViewController
    StreamTableViewManager *streamTableViewManager = [[StreamTableViewManager alloc] init];

    GuideTableViewController *streamViewController = [[GuideTableViewController alloc] initWithNibName:@"GuideTableViewController" bundle:nil];
    [streamViewController loadWithType:GuideType_Stream forTableViewManager:streamTableViewManager withPullToRefreshEnabled:YES];
    
    //    GuideTableViewController *streamViewController = [[GuideTableViewController alloc] initWithType:GuideType_Stream 
//                                                                                forTableViewManager:streamTableViewManager 
//                                                                           withPullToRefreshEnabled:YES];
    UINavigationController *streamNavigationController = [[UINavigationController alloc] initWithRootViewController:streamViewController];
    [streamNavigationController setNavigationBarHidden:YES];
    
    // Pass streamNavigationController reference to streamTableViewManager
    streamTableViewManager.navigationController = streamNavigationController;
    
    // Customize tabBarItem for Stream
    NSDictionary *streamDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Ubuntu-Bold" size:10.0f], UITextAttributeFont,
                                      [UIColor colorWithRed:98.0f/255.0f green:188.0f/255.0f blue:86.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [streamViewController.tabBarItem setTitleTextAttributes:streamDictionary forState:UIControlStateSelected];
    [streamViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"streamOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"streamOff"]];
    [streamViewController setTitle:@"Stream"];
    
    // Set navigationController as window's rootViewController
    self.window.rootViewController = streamNavigationController;
    
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
        [[SocialFacade sharedInstance] setLoginViewController:loginViewController];
        
    } else {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
        [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
        [[SocialFacade sharedInstance] setLoginViewController:loginViewController];
    }
}

@end