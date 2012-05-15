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
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - UIApplicationDelegate Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Instantiate UIWindow
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Instantiate managedObjectContext
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
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
    return [[[SocialFacade sharedInstance] facebook] handleOpenURL:url];
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    // Save changes to managedObjectContext before shutdown.
    [CoreDataUtility saveContext:self.managedObjectContext];
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
    GuideTableViewController *streamViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeStream andTableViewManager:streamTableViewManager];
    UINavigationController *streamNavigationController = [[UINavigationController alloc] initWithRootViewController:streamViewController];
    
    // Pass streamNavigationController reference to streamTableViewManager
    streamTableViewManager.navigationController = streamNavigationController;
    
    // Customize tabBarItem for Stream
    NSDictionary *streamDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Ubuntu-Bold" size:10.0f], UITextAttributeFont,
                                      [UIColor colorWithRed:98.0f/255.0f green:188.0f/255.0f blue:86.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [streamViewController.tabBarItem setTitleTextAttributes:streamDictionary forState:UIControlStateSelected];
    [streamViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"streamOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"streamOff"]];
    [streamViewController setTitle:@"Stream"];
    
    
    ///* ROLLS *///
    
    // Create rollsTableViewController and populate it with youRollsTableViewManager (population performed by rollsTableViewController's initWithRollsType: method)
    RollsTableViewController *rollsTableViewController = [[RollsTableViewController alloc] initWithRollsType:RollsTypeYour];
    
    // Create rollsNavigationController
    UINavigationController *rollsNavigationController = [[UINavigationController alloc] initWithRootViewController:rollsTableViewController];
    
    // Pass rollsNavigationController reference to rollsTableViewController
    rollsTableViewController.navigationController = rollsNavigationController;
    
    // Customize tabBarItem for Rolls
    NSDictionary *rollsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Ubuntu-Bold" size:10.0f], UITextAttributeFont,
                                     [UIColor colorWithRed:0.0f/255.0f green:146.0f/255.0f blue:193.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [rollsTableViewController.tabBarItem setTitleTextAttributes:rollsDictionary forState:UIControlStateSelected];
    [rollsTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"rollsOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"rollsOff"]];
    [rollsTableViewController setTitle:@"Rolls"];
    
    
    ///* SAVES *///
    
    // Create savesNavigationViewController
    SavesTableViewManager *savesTableViewManager = [[SavesTableViewManager alloc] init];
    GuideTableViewController *savesViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeSaves andTableViewManager:savesTableViewManager];
    UINavigationController *savesNavigationController = [[UINavigationController alloc] initWithRootViewController:savesViewController];
    
    // Pass savesNavigationController reference to savesTableViewManager
    savesTableViewManager.navigationController = savesNavigationController;
    
    // Customize tabBarItem for Saves
    NSDictionary *savesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Ubuntu-Bold" size:10.0f], UITextAttributeFont,
                                      [UIColor colorWithRed:141.0f/255.0f green:82.0f/255.0f blue:154.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [savesViewController.tabBarItem setTitleTextAttributes:savesDictionary forState:UIControlStateSelected];
    [savesViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"savesOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"savesOff"]];
    [savesViewController setTitle:@"Saves"];

    
    ///* SEARCH *///
    
    // Create searchNavigationController
    SearchTableViewManager *searchTableViewManager = [[SearchTableViewManager alloc] init];
    GuideTableViewController *searchViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeSearch andTableViewManager:searchTableViewManager];
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    
    // Pass searchNavigationController reference to searchTableViewManager
    searchTableViewManager.navigationController = searchNavigationController;
    
    // Customize tabBarItem for Search
    NSDictionary *searchDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Ubuntu-Bold" size:10.0f], UITextAttributeFont,
                                      [UIColor colorWithRed:227.0f/255.0f green:59.0f/255.0f blue:46.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [searchViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"searchOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"searchOff"]];
    [searchViewController.tabBarItem setTitleTextAttributes:searchDictionary forState:UIControlStateSelected];
    [searchViewController setTitle:@"Search"];
    
    
    ///* YOU *///
    
    // Create youNavigationController
    YouTableViewController *youTableViewController = [[YouTableViewController alloc] init];
    UINavigationController *youNavigationController = [[UINavigationController alloc] initWithRootViewController:youTableViewController];
    
    // Pass youNavigationController reference to youTableViewController
    youTableViewController.navigationController = youNavigationController;
    
    // Customize tabBarItem for You
    NSDictionary *youDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont fontWithName:@"Ubuntu-Bold" size:10.0f], UITextAttributeFont,
                                   [UIColor colorWithRed:239.0f/255.0f green:232.0f/255.0f blue:75.0f/255.0f alpha:1.0f], UITextAttributeTextColor, nil];
    [youTableViewController.tabBarItem setTitleTextAttributes:youDictionary forState:UIControlStateSelected];
    [youTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"youOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"youOff"]];
    [youTableViewController setTitle:@"You"];
    
    ///* TAB BAR CONTROLLER*
    
    // Create UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray *tabBarArray = [NSArray arrayWithObjects:streamNavigationController, rollsNavigationController, savesNavigationController, searchNavigationController, youNavigationController, nil];
    tabBarController.viewControllers = tabBarArray;
    
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

#pragma mark - Core Data Methods
/**

 Returns the application's instance of NSManagedObjectConteext.
 If an instance doesn't exist, it's created and bound to the application's instance of NSPersistentStoreCoordinator.
 
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if ( self.managedObjectContext )
    {
        return self.managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if ( coordinator )
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
        [self.managedObjectContext setUndoManager:nil];
        [self.managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    return self.managedObjectContext;
}

/**
 Returns the application's instance of NSManagedObjectModel.
 If an instance of the model doesn't exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    
    if ( self.managedObjectModel )
    {
        return self.managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Shelby" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return self.managedObjectModel;

}

/**
 Returns the application's instance NSPersistentStoreCoordinator.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if ( self.persistentStoreCoordinator )
    {
        return self.persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Shelby-tv.sqlite"];
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if ( ![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error] )
    {
        // Delete datastore if there's a conflict. User can re-login to repopulate the datastore.
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        // Retry
        if ( ![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error] )
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    return self.persistentStoreCoordinator;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end