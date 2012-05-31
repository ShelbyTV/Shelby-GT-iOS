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
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        // Fetch date stored in Core Data
        DashboardEntry *dashboardEntry = [CoreDataUtility fetchDashboardEntryDataForRow:row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Populate roll label
            [cell.rollLabel setText:dashboardEntry.frame.roll.title];
            
            // Populate nickname label
            [cell.nicknameLabel setText:dashboardEntry.frame.user.nickname];
            
            // Populate comments label
            [cell.commentsLabel setText:[NSString stringWithFormat:@"%@", dashboardEntry.frame.conversation.messageCount]];
        
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
            if ( dashboardEntry.frame.user.userImage ) { // Occassionally, this is nil. Dan Spinosa is currently addressing this bug.
                
                [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.user.userImage forImageView:cell.userImageView withPlaceholderView:nil];
            
            } else if ( message.userImageURL ) {    // Use this image (which is never nil) until Spinosa addresses issue.
                
                [AsynchronousFreeloader loadImageFromLink:message.userImageURL forImageView:cell.userImageView withPlaceholderView:nil];
            }

            // Asynchronous download of video thumbnail
            [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.video.thumbnailURL forImageView:cell.thumbnailImageView withPlaceholderView:nil];
    
            });
                
        });
        
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

    // Hide cell until it's populated with information
    [cell setHidden:YES];
    
    // Populate UITableView row with content if content exists (CHANGE THIS CONDITION TO BE CORE-DATA DEPENDENT)
    if ( [self.parsedResultsArray objectAtIndex:indexPath.row] ) {
     
        
        [self populateTableViewCell:cell withContentForRow:indexPath.row];
        
        // Animate cell as data populates
        [cell setHidden:NO];
        [cell setAlpha:0.0f];
        [UIView animateWithDuration:0.3 animations:^{
            [cell setAlpha:1.0f];
        }];
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

@end