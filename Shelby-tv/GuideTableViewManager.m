//
//  GuideTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GuideTableViewManager.h"

@implementation GuideTableViewManager
@synthesize refreshController = _refreshController;
@synthesize guideController = _guideController;
@synthesize parsedResultsArray = _parsedResultsArray;
@synthesize coreDataResultsArray = _coreDataResultsArray;
@synthesize tableView = _tableView;

#pragma mark - Public Methods
+ (void)performAPIRequestOfType:(GuideType)type forRollID:(NSString*)rollID;
{
    switch ( type ) {
            
        case GuideType_BrowseRolls:{
            
            NSString *requestString = [NSString stringWithFormat:APIRequest_GetBrowseRolls, [SocialFacade sharedInstance].shelbyToken];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
            ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
            [client performRequest:request ofType:type];
            
        } break;
            
        case GuideType_MyRolls:{
            
            NSString *requestString = [NSString stringWithFormat:APIRequest_GetRollFrames, rollID, [SocialFacade sharedInstance].shelbyToken];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
            ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
            [client performRequest:request ofType:type];
            
        } break;
            
        case GuideType_PeopleRolls:{
            
            NSString *requestString = [NSString stringWithFormat:APIRequest_GetRollFrames, rollID, [SocialFacade sharedInstance].shelbyToken];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
            ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
            [client performRequest:request ofType:type];
            
        } break;
            
        default:
            break;
    }
    

}

#pragma mark - GuideTableViewManagerDelegate methods
- (void)loadDataOnInitializationForTableView:(UITableView *)tableView
{
    // Do nothing in GuideTableViewManager
}

- (void)loadDataFromCoreData;
{
    // Do nothing in GuideTableViewManager
}

- (void)performAPIRequest
{
    // Do nothing in GuideTableViewManager
}

- (void)dataReturnedFromAPI:(NSNotification *)notification
{
    // Do nothing in GuideTableViewManager
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    [self.refreshController scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    [self.refreshController scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    [self.refreshController scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end