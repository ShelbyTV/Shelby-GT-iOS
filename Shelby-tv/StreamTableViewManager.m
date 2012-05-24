//
//  StreamTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StreamTableViewManager.h"
#import "VideoCardCell.h"
#import "AsynchronousFreeloader.h"

@interface StreamTableViewManager ()

@property (assign, nonatomic) BOOL observerCreated;

- (void)createAPIObservers;
- (void)populateTableViewCell:(VideoCardCell*)cell withContentForRow:(NSInteger)row;

@end

@implementation StreamTableViewManager 
@synthesize observerCreated = _observerCreated;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)createAPIObservers
{
    NSString *notificationName = [NSString apiRequestTypeToString:APIRequestTypeStream];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(dataReturnedFromAPI:) 
                                                 name:notificationName 
                                               object:nil];
    self.observerCreated = YES;
}

- (void)populateTableViewCell:(VideoCardCell *)cell withContentForRow:(NSInteger)row
{
    // Fetch date stored in Core Data
    NSManagedObjectContext *context = [CoreDataUtility sharedInstance].managedObjectContext;
    DashboardEntry *dashboardEntry = [CoreDataUtility fetchDashboardEntryData:context forRow:row];
    
    // Populate nickname label
    [cell.nicknameLabel setText:dashboardEntry.frame.user.nickname];
    
    // Populate nickname label
//    [cell.createdAtLabel setText:dashboardEntry.frame.conversation.messages.createdAt];
//        
//    // PresentFacebook/Twitter/Tumblr icon for social network source of video
//    if ( [dashboardEntry.frame.conversation.messages.originNetwork isEqualToString:@"facebook"] ) {
//    
//        [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampFacebook"]];
//   
//    } else if ( [dashboardEntry.frame.conversation.messages.originNetwork isEqualToString:@"twitter"] ) {
//    
//        [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampTwitter"]];
//        
//    } else if ( [dashboardEntry.frame.conversation.messages.originNetwork isEqualToString:@"tumblr"] ) {
//        
//        [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampTumblr"]];
//        
//    } else {
//        
//        // Do nothing for nil state
//    }
    
    // Asychronous download of user image/icon
    if ( dashboardEntry.frame.user.userImage ) {
        
        [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.user.userImage forImageView:cell.userImageView withPlaceholderView:nil];
    }

    // Asynchronous download of video thumbnail
    [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.video.thumbnailURL forImageView:cell.thumbnailImageView withPlaceholderView:nil];

}

#pragma mark - GuideTableViewManagerDelegate Method
- (void)performAPIRequestForTableView:(UITableView *)tableView
{

    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Reference Parent ViewController's UITableView (should ONLY occur on first call to this method)
    if ( ![self tableView] ) self.tableView = tableView;
    
    // Peeform API Request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kAPIRequestStream]];

    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestTypeStream];
    
}

- (void)dataReturnedFromAPI:(NSNotification*)notification
{

    // Hide ASPullToRefreshController's HeaderView
    [self.refreshController didFinishRefreshing];
    
    // Store array from NSNotification, locally
    NSDictionary *parsedDictionary = notification.userInfo;
    self.parsedResultsArray = [parsedDictionary objectForKey:kAPIResult];
        
    // Reload tableView
    [self.tableView reloadData];

}

#pragma mark - ASPullToRefreshDelegate Method
- (void)dataToRefresh
{
    // Perform API Request for tableView, which WILL/SHOULD/MUST exist before this method is called
    if ( [self tableView] ) [self performAPIRequestForTableView:self.tableView];
}

#pragma mark - UITableViewDatasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 242.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( self.parsedResultsArray ) ? [self.parsedResultsArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // For Testing Purposes
    static NSString *CellIdentifier = @"Cell";
    VideoCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( nil == cell ) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCardCell" owner:self options:nil];
        cell = (VideoCardCell*)[nib objectAtIndex:0];
          
    }

    // Populate UITableView row with content
    if ( [self.parsedResultsArray objectAtIndex:indexPath.row] ) [self populateTableViewCell:cell withContentForRow:indexPath.row];      
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end