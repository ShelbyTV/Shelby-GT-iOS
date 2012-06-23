//
//  BrowseRollsTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/12/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "BrowseRollsTableViewManager.h"
#import "RollsCell.h"

@interface BrowseRollsTableViewManager ()
@property (assign, nonatomic) BOOL observerCreated;

- (void)createAPIObservers;

@end

@implementation BrowseRollsTableViewManager

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString apiRequestTypeToString:APIRequestType_GetBrowseRolls] object:nil];
}


#pragma mark - Private Methods
- (void)createAPIObservers
{
    
    NSString *notificationName = [NSString apiRequestTypeToString:APIRequestType_GetStream];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReturnedFromAPI:)
                                                 name:notificationName
                                               object:nil];
    self.observerCreated = YES;
}

#pragma mark - GuideTableViewMangerDelegate Methods
- (void)loadDataOnInitializationForTableView:(UITableView*)tableView
{
    // Reference Parent ViewController's UITableView (should ONLY occur on first call to this method)
    self.tableView = tableView;
    
    // Load stored data into tableView
    [self loadDataFromCoreData];
}

- (void)loadDataFromCoreData
{
    // Fetch Stream / DashboardEntry Data from Core Data
    
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) {
        
        self.coreDataResultsArray = [CoreDataUtility fetchAllBrowseRolls];
        
        [self.tableView reloadData];
        
    }
    
}

- (void)performAPIRequest
{
    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Perform API Request
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetBrowseRolls, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_GetBrowseRolls];
}

- (void)dataReturnedFromAPI:(NSNotification*)notification
{
    // Hide ASPullToRefreshController's HeaderView
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.refreshController didFinishRefreshing];
        [self loadDataFromCoreData];
        
    });
}

#pragma mark - ASPullToRefreshDelegate Methods
- (void)dataToRefresh
{
    [self.refreshController didFinishRefreshing];
}

@end
