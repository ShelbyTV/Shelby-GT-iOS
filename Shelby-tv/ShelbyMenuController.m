//
//  ShelbyMenuController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/12/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyMenuController.h"
#import "ShelbyMenuView.h"
#import "GuideTableViewController.h"
#import "TableViewManagers.h"

@interface ShelbyMenuController ()

@property (strong, nonatomic) NSMutableDictionary *dictionaryOfMenuItems;

- (void)createMenu;
- (void)presentMenuItem:(UINavigationController*)menuItem;
- (NSString*)dictionaryKeyMaker:(GuideType)type;

@end

@implementation ShelbyMenuController
@synthesize rootViewController = _rootViewController;
@synthesize dictionaryOfMenuItems = _dictionaryOfMenuItems;

#pragma mark - Initialization Method

- (id)init
{
    if ( self = [super init] ) {
        
        /// General Memory Allocation
        self.dictionaryOfMenuItems = [NSMutableDictionary dictionary];
        
        // Create Navigation Menu
        [self createMenu];
        
        NSLog(@"%@", self.dictionaryOfMenuItems);
        
        // Set menu's rootViewController (to be passed to UIWindow's rootViewController property)
        self.rootViewController = [self.dictionaryOfMenuItems objectForKey:[self dictionaryKeyMaker:GuideType_Stream]];
        
    }
        
    return self;
}

#pragma mark - Public Methods
- (IBAction)browseRollsButton
{
    [self presentMenuItem:[self.dictionaryOfMenuItems objectForKey:[self dictionaryKeyMaker:GuideType_BrowseRolls]]];
}

- (IBAction)myRollsButton
{
    [self presentMenuItem:[self.dictionaryOfMenuItems objectForKey:[self dictionaryKeyMaker:GuideType_MyRolls]]];
}

- (IBAction)peopleRollsButton
{
    [self presentMenuItem:[self.dictionaryOfMenuItems objectForKey:[self dictionaryKeyMaker:GuideType_PeopleRolls]]];
}

- (IBAction)settingsButton
{
    [self presentMenuItem:[self.dictionaryOfMenuItems objectForKey:[self dictionaryKeyMaker:GuideType_Settings]]];
}

- (IBAction)streamButton
{
    [self presentMenuItem:[self.dictionaryOfMenuItems objectForKey:[self dictionaryKeyMaker:GuideType_Stream]]];
}

#pragma mark - Private Methods
- (NSString*)dictionaryKeyMaker:(GuideType)type
{
    return [NSString stringWithFormat:@"Table%d", type];
}

- (void)createMenu
{

    /// *** Stream *** ///
    StreamTableViewManager *streamTableViewManager = [[StreamTableViewManager alloc] init];
    
    GuideTableViewController *streamViewController = [[GuideTableViewController alloc] initWithType:GuideType_Stream 
                                                                                forTableViewManager:streamTableViewManager 
                                                                           withPullToRefreshEnabled:YES];
    
    UINavigationController *streamNavigationController = [[UINavigationController alloc] initWithRootViewController:streamViewController];
    streamTableViewManager.navigationController = streamNavigationController;
    
    [self.dictionaryOfMenuItems setObject:streamNavigationController forKey:[self dictionaryKeyMaker:GuideType_Stream]];
    
    
    /// *** People Rolls *** ///
    PeopleRollsTableViewManager *peopleRollsTableViewManager = [[PeopleRollsTableViewManager alloc] init];
    
    GuideTableViewController *peopleRollsViewController = [[GuideTableViewController alloc] initWithType:GuideType_PeopleRolls 
                                                                                     forTableViewManager:peopleRollsTableViewManager 
                                                                                withPullToRefreshEnabled:YES];
    
    UINavigationController *peopleRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:peopleRollsViewController];
    peopleRollsTableViewManager.navigationController = peopleRollsNavigationController;
    
    [self.dictionaryOfMenuItems setObject:peopleRollsNavigationController forKey:[self dictionaryKeyMaker:GuideType_PeopleRolls]];
    
    /// *** My Rolls *** ///
    MyRollsTableViewManager *myRollsTableViewManager = [[MyRollsTableViewManager alloc] init];
    
    GuideTableViewController *myRollsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_MyRolls 
                                                                                      forTableViewManager:myRollsTableViewManager 
                                                                                 withPullToRefreshEnabled:YES];
    
    UINavigationController *myRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:myRollsTableViewController];
    myRollsTableViewManager.navigationController = myRollsNavigationController;
    
    [self.dictionaryOfMenuItems setObject:myRollsNavigationController forKey:[self dictionaryKeyMaker:GuideType_MyRolls]];
    
    /// *** Browse Rolls *** ///
    BrowseRollsTableViewManager *browseRollsTableViewManager = [[BrowseRollsTableViewManager alloc] init];
    
    GuideTableViewController *browseRollsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_BrowseRolls 
                                                                                          forTableViewManager:browseRollsTableViewManager 
                                                                                     withPullToRefreshEnabled:YES];
    
    UINavigationController *browseRollsNavigationController = [[UINavigationController alloc] initWithRootViewController:browseRollsTableViewController];
    browseRollsTableViewManager.navigationController = browseRollsNavigationController;
    
    [self.dictionaryOfMenuItems setObject:browseRollsNavigationController forKey:[self dictionaryKeyMaker:GuideType_BrowseRolls]];
    
    /// *** Settings *** ///
    SettingsTableViewManager *settingsTableViewManager = [[SettingsTableViewManager alloc] init];
    
    GuideTableViewController *settingsTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_Settings 
                                                                                       forTableViewManager:settingsTableViewManager 
                                                                                  withPullToRefreshEnabled:NO];
    
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsTableViewController];
    settingsTableViewManager.navigationController = settingsNavigationController;
    
    [self.dictionaryOfMenuItems setObject:settingsNavigationController forKey:[self dictionaryKeyMaker:GuideType_Settings]];

}

- (void)presentMenuItem:(UINavigationController*)menuItem
{
    
}

@end