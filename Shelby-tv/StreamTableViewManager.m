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
- (void)populateTableViewCell:(VideoCardCell*)cell withContentForRow:(NSUInteger)row;
- (void)animateCell:(VideoCardCell*)cell forRow:(NSUInteger)row;

@end

@implementation StreamTableViewManager 
@synthesize observerCreated = _observerCreated;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString apiRequestTypeToString:APIRequestTypeGetStream] object:nil];
}


#pragma mark - Private Methods
- (void)createAPIObservers
{
    
    NSString *notificationName = [NSString apiRequestTypeToString:APIRequestTypeGetStream];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(dataReturnedFromAPI:) 
                                                 name:notificationName 
                                               object:nil];
    self.observerCreated = YES;
}

- (void)populateTableViewCell:(VideoCardCell *)cell withContentForRow:(NSUInteger)row
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        // Fetch date stored in Core Data
        DashboardEntry *dashboardEntry = [self.coreDataResultsArray objectAtIndex:row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Populate roll label
            [cell.rollLabel setText:dashboardEntry.frame.roll.title];
            
            // Populate nickname label
            [cell.nicknameLabel setText:dashboardEntry.frame.creator.nickname];
            
            // Populate favorite label
            [cell.upvoteLabel setText:[NSString stringWithFormat:@"%@", dashboardEntry.frame.upvotersCount]];
            
            // Populate comments label
            [cell.commentLabel setText:[NSString stringWithFormat:@"%@", dashboardEntry.frame.conversation.messageCount]];
        
            // Fetch messages specific to dashboardEntry
            Messages *message = [CoreDataUtility fetchFirstMessageFromConversation:dashboardEntry.frame.conversation];
            
            // Populate createdAt label
            [cell.createdAtLabel setText:message.createdAt];
                
            // PresentFacebook/Twitter/Tumblr icon for social network source of video
            if ( [message.originNetwork isEqualToString:@"facebook"] ) {
            
                [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampFacebook"]];
           
            } else if ( [message.originNetwork isEqualToString:@"twitter"] ) {
            
                [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampTwitter"]];
                
            } else if ( [message.originNetwork isEqualToString:@"tumblr"] ) {
                
                [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampTumblr"]];
                
            } else {
                
                // Do nothing for nil state
            }
            
            // Asychronous download of user image/icon
            if ( dashboardEntry.frame.creator.userImage ) { // Occassionally, this is nil. Dan Spinosa is currently addressing this bug.
                
                [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.creator.userImage forImageView:cell.userImageView withPlaceholderView:nil];
            
            } else if ( message.userImageURL ) {    // Use this image (which is never nil) until Spinosa addresses issue.
                
                [AsynchronousFreeloader loadImageFromLink:message.userImageURL forImageView:cell.userImageView withPlaceholderView:nil];
            }

            // Asynchronous download of video thumbnail
            [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.video.thumbnailURL forImageView:cell.thumbnailImageView withPlaceholderView:nil];
    
            });
                
        });
        
}

- (void)animateCell:(VideoCardCell *)cell forRow:(NSUInteger)row
{
    
    [UIView animateWithDuration:0.50 
                     animations:^{
        [cell setAlpha:1.0f];
    }];
}

#pragma mark - GuideTableViewManagerDelegate Method
- (void)loadDataOnInitializationForTableView:(UITableView *)tableView
{

    
    // Reference Parent ViewController's UITableView (should ONLY occur on first call to this method)
    self.tableView = tableView;
    
    // Load stored data into tableView (if it exists)
    [self loadDataFromCoreData];
    
}

- (void)loadDataFromCoreData
{
    // Fetch Stream / DashboardEntry Data from Core Data
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) {
     
        self.coreDataResultsArray = [CoreDataUtility fetchAllDashboardEntries];

        [self.tableView reloadData];
        
    }
}

- (void)performAPIRequest
{

    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Peeform API Request
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetStream, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];

    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestTypeGetStream];
    
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
    return ( self.coreDataResultsArray ) ?  [self.coreDataResultsArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // For Testing Purposes
    static NSString *CellIdentifier = @"Cell";
    VideoCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( (nil == cell) || (0 == indexPath.row) ) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCardCell" owner:self options:nil];
        cell = (VideoCardCell*)[nib objectAtIndex:0];
    }
    
    // Pseudo-hide cell until it's populated with information
    [cell setAlpha:0.0f];
    
    // Populate UITableView row with content if content exists (CHANGE THIS CONDITION TO BE CORE-DATA DEPENDENT)
    if ( [self.coreDataResultsArray count]  ) {
     
        if ( [self.coreDataResultsArray objectAtIndex:indexPath.row] ) {
        
            if ( [cell isMemberOfClass:[VideoCardCell class]] ) [self populateTableViewCell:cell withContentForRow:indexPath.row];
            
            // Animate cell as data populates
            [self animateCell:cell forRow:indexPath.row];
            
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end