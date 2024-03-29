//
//  MyRollsTableViewManager.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/12/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "MyRollsTableViewManager.h"
#import "GuideTableViewController.h"
#import "RollsCell.h"

@interface MyRollsTableViewManager ()
@property (assign, nonatomic) BOOL observerCreated;

- (void)createAPIObservers;

@end

@implementation MyRollsTableViewManager

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString requestTypeToString:APIRequestType_GetRollsFollowing] object:nil];
}


#pragma mark - Private Methods
- (void)createAPIObservers
{
    
    NSString *notificationName = [NSString requestTypeToString:APIRequestType_GetRollsFollowing];
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
    // Fetch Rolls-Following Data from Core Data
    
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) {
        
        self.coreDataResultsArray = [CoreDataUtility fetchMyRolls];
        
        [self.tableView reloadData];
        
    }
    
}

- (void)performAPIRequest
{
    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Perform API Request
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetRollsFollowing, [SocialFacade sharedInstance].shelbyCreatorID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_GetRollsFollowing];
}

- (void)dataReturnedFromAPI:(NSNotification*)notification
{
    
    // Hide ASPullToRefreshController's HeaderView
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.refreshController didFinishRefreshing];
        [self loadDataFromCoreData];
        
    });
    
}

#pragma mark - ASPullToRefreshDelegate Method
- (void)dataToRefresh
{
    // Perform API Request for tableView, which WILL/SHOULD/MUST exist before this method is called
    [self performAPIRequest];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( self.coreDataResultsArray ) ? [self.coreDataResultsArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RollsCell" owner:self options:nil];
    RollsCell *cell = (RollsCell*)[nib objectAtIndex:0];
    
    Roll *roll= [self.coreDataResultsArray objectAtIndex:indexPath.row];
    [AsynchronousFreeloader loadImageFromLink:roll.thumbnailURL forImageView:cell.coverImageView withPlaceholderView:nil];
    [cell.creatorNameLabel setText:roll.creatorNickname];
    [cell.rollNameLabel setText:roll.title];
    [cell.frameCountLabel setText:[NSString stringWithFormat:@"%d videos", [roll.frameCount intValue]]];

    NSString *personWatching = @"1 person watching";
    NSString *peopleWatching = [NSString stringWithFormat:@"%d people watching", [roll.followingCount intValue]];
    cell.followingCountLabel.text = ( 1 == [roll.followingCount intValue] ) ? personWatching : peopleWatching;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Roll *roll= [self.coreDataResultsArray objectAtIndex:indexPath.row];
    GuideTableViewController *rollFramesTableViewController = [[GuideTableViewController alloc] initWithType:GuideType_RollFrames navigationController:self.guideController.navigationController  andRollID:roll.rollID];
    [self.guideController.navigationController pushViewController:rollFramesTableViewController animated:YES];
}

@end