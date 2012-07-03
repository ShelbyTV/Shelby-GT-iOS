//
//  StreamTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StreamTableViewManager.h"
#import "VideoCardController.h"

@interface StreamTableViewManager ()

@property (assign, nonatomic) BOOL observerCreated;
@property (strong, nonatomic) NSMutableArray *arrayOfFrameIDs;

- (void)createAPIObservers;
- (void)populateTableViewCell:(VideoCardCell*)cell withContent:(DashboardEntry*)dashboardEntry inRow:(NSUInteger)row;

- (void)upvote:(UIButton *)button;
- (void)downvote:(UIButton *)button;

@end

@implementation StreamTableViewManager 
@synthesize observerCreated = _observerCreated;
@synthesize arrayOfFrameIDs = _arrayOfFrameIDs;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString apiRequestTypeToString:APIRequestType_GetStream] object:nil];
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

- (void)populateTableViewCell:(VideoCardCell *)cell withContent:(DashboardEntry *)dashboardEntry inRow:(NSUInteger)row
{

        // General Initializations
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [cell setTag:row];
        [cell.upvoteButton setTag:row];
        
        // Store Frame ID
        if ( ![self arrayOfFrameIDs] ) self.arrayOfFrameIDs = [NSMutableArray array];
        [self.arrayOfFrameIDs addObject:dashboardEntry.frame.frameID];
        
        // Populate roll label
        [cell.rollLabel setText:dashboardEntry.frame.roll.title];
        
        // Populate nickname label
        [cell.nicknameLabel setText:dashboardEntry.frame.creator.nickname];
        
        // Present Heart/Unheart button (depends if user already liked video)
        BOOL upvoted = [CoreDataUtility checkIfUserUpvotedInFrame:dashboardEntry.frame];
        
        if ( upvoted ) { // Make sure Heart is Red and user is able to Downvote
            
            [cell.upvoteButton setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateNormal];
            [cell.upvoteButton setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateHighlighted];
            [cell.upvoteButton removeTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.upvoteButton addTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
            
        } else { // Make sure Heart is Gray and user is able to Upvote
            
            [cell.upvoteButton setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateNormal];
            [cell.upvoteButton setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateHighlighted];
            [cell.upvoteButton removeTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.upvoteButton addTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        // Populate Upvote Button label
        [cell.upvoteButton setTitle:[NSString stringWithFormat:@"%@", dashboardEntry.frame.upvotersCount] forState:UIControlStateNormal];
        
        // Populate comments label
        [cell.commentButton setTitle:[NSString stringWithFormat:@"%@", dashboardEntry.frame.conversation.messageCount] forState:UIControlStateNormal];
    
        // Fetch messages specific to dashboardEntry (may return nil, but that's ok!)
        Messages *message = [CoreDataUtility fetchFirstMessageFromConversation:dashboardEntry.frame.conversation];
        
        // Populate createdAt label
        [cell.createdAtLabel setText:message.createdAt];
                
        if ( message ) { // If message exists, present Facebook/Twitter/Tumblr icon for social network source of video

        
            if ( [message.originNetwork isEqualToString:@"facebook"] ) {
            
                [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampFacebook"]];
           
            } else if ( [message.originNetwork isEqualToString:@"twitter"] ) {
            
                [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampTwitter"]];
                
            } else if ( [message.originNetwork isEqualToString:@"tumblr"] ) {
                
                [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampTumblr"]];
                
            } else {
                
                // Do nothing for nil state
            }
            
        }
    
        // Asychronous download of user image/icon
        if ( dashboardEntry.frame.creator.userImage ) {
            
            [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.creator.userImage forImageView:cell.userImageView withPlaceholderView:nil];
        
        } 

        // Asynchronous download of video thumbnail
        [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.video.thumbnailURL forImageView:cell.thumbnailImageView withPlaceholderView:nil];

    });
        
}

- (void)upvote:(UIButton *)button
{
    if ( DEBUGMODE ) NSLog(@"Upvote row %d with value: %@", button.tag, [self.arrayOfFrameIDs objectAtIndex:button.tag]);

    NSUInteger upvoteCount = [button.titleLabel.text intValue];
    upvoteCount++;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [button setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateHighlighted];
        [button removeTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%d", upvoteCount] forState:UIControlStateNormal];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized(self) {
            // Quickly modify Core Data values
            ShelbyUser *shelbyUser = [CoreDataUtility fetchShelbyAuthData];
            DashboardEntry *dashboardEntry = [CoreDataUtility fetchDashboardEntryDataForRow:button.tag];
            Frame *frame = dashboardEntry.frame;
            
            UpvoteUsers *upvoteUsers = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityUpvoteUsers inManagedObjectContext:dashboardEntry.managedObjectContext];
            [upvoteUsers setValue:shelbyUser.shelbyID forKey:CoreDataUpvoteUserID];
            [upvoteUsers setValue:shelbyUser.nickname forKey:CoreDataUpvoteUsersNickname];
            [upvoteUsers setValue:shelbyUser.userImage forKey:CoreDataUpvoteUsersImage];
            [upvoteUsers setValue:frame.rollID forKey:CoreDataUpvoteUsersRollID];
            [frame addUpvoteUsersObject:upvoteUsers];
            [frame setValue:[NSNumber numberWithInt:upvoteCount] forKey:CoreDataFrameUpvotersCount];
            
            [CoreDataUtility saveContext:frame.managedObjectContext];
        }
    });
    
    // Ping API with new values
    VideoCardController *controller = [[VideoCardController alloc] initWithFrameID:[self.arrayOfFrameIDs objectAtIndex:button.tag]];
    [controller upvote];
    
    
}

- (void)downvote:(UIButton *)button
{
    if ( DEBUGMODE ) NSLog(@"Downvote row %d with value: %@", button.tag, [self.arrayOfFrameIDs objectAtIndex:button.tag]);
    
    NSUInteger upvoteCount = [button.titleLabel.text intValue];
    upvoteCount--;
    
    dispatch_async(dispatch_get_main_queue(), ^{
            [button setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateHighlighted];
            [button removeTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[NSString stringWithFormat:@"%d", upvoteCount] forState:UIControlStateNormal];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
        @synchronized(self) {
            // Quickly modify Core Data values
            DashboardEntry *dashboardEntry = [CoreDataUtility fetchDashboardEntryDataForRow:button.tag];
            Frame *frame = dashboardEntry.frame;
            
            NSMutableSet *upvoteUsers = [NSMutableSet setWithSet:frame.upvoteUsers];
            
            for (UpvoteUsers *user in [upvoteUsers allObjects]) {
                
                if ( [user.upvoterID isEqualToString:[SocialFacade sharedInstance].shelbyCreatorID] ) {
                    
                    [frame removeUpvoteUsersObject:user];
                    
                }
                
            }
            
            [frame setValue:[NSNumber numberWithInt:upvoteCount] forKey:CoreDataFrameUpvotersCount];
            
            [CoreDataUtility saveContext:frame.managedObjectContext];
        }
    });
        
    // Ping API with new values
    VideoCardController *controller = [[VideoCardController alloc] initWithFrameID:[self.arrayOfFrameIDs objectAtIndex:button.tag]];
    [controller downvote];
}

#pragma mark - GuideTableViewManagerDelegate Method
- (void)loadDataOnInitializationForTableView:(UITableView *)tableView
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
     
        self.coreDataResultsArray = [CoreDataUtility fetchAllDashboardEntries];
            
        [self.tableView reloadData];
        
    }
    
}

- (void)performAPIRequest
{

    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Perform API Request
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetStream, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_GetStream];

}

- (void)performAPIRequestForMoreEntries
{
    
    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Perform API Request
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetStreamAgain, [SocialFacade sharedInstance].shelbyToken, [self.coreDataResultsArray count]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_GetStream];
    
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
    
    // Fetch data stored in Core Data
    DashboardEntry *dashboardEntry = [self.coreDataResultsArray objectAtIndex:indexPath.row];
    
    // Create proper cell based on number of upvotes
    NSUInteger upvotersCount = [dashboardEntry.frame.upvotersCount intValue];
    
    if ( upvotersCount > 0 ) {

        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCardExpandedCell" owner:self options:nil];
        VideoCardExpandedCell *cell = (VideoCardExpandedCell*)[nib objectAtIndex:0];
        
        NSUInteger userCounter = 0;
        NSMutableArray *upvoteUsersarray = [NSMutableArray arrayWithArray:[dashboardEntry.frame.upvoteUsers allObjects]];
        
        while ( userCounter < [upvoteUsersarray count] ) {
            
            UpvoteUsers *user = [upvoteUsersarray objectAtIndex:userCounter];
            
            for (UIImageView *imageView in [cell subviews] ) {
                
                if ( (imageView.tag == userCounter) && (userCounter < 10) && [imageView isMemberOfClass:[UIImageView class]] ) {
                    
                    [AsynchronousFreeloader loadImageFromLink:user.userImage forImageView:imageView withPlaceholderView:nil];
                    
                }
                
            }
            
            userCounter++;
        }
        
        // Pseudo-hide cell until it's populated with information
        [cell setAlpha:0.0f];
        
        if ( [self.coreDataResultsArray count]  ) {
            
            if ( [self.coreDataResultsArray objectAtIndex:indexPath.row] ) {
                
                if ( dashboardEntry.frame != nil ) [self populateTableViewCell:cell withContent:dashboardEntry inRow:indexPath.row];
                
            }
        }
        
        
        return cell;
        
    } else {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCardCell" owner:self options:nil];
        VideoCardCell *cell = (VideoCardCell*)[nib objectAtIndex:0];
    
        // Pseudo-hide cell until it's populated with information
        [cell setAlpha:0.0f];
        
        if ( [self.coreDataResultsArray count]  ) {
            
            if ( [self.coreDataResultsArray objectAtIndex:indexPath.row] ) {
                
                [self populateTableViewCell:cell withContent:dashboardEntry inRow:indexPath.row];
                
            }
        }
        
        return cell;
        
    }
    
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == ([self.coreDataResultsArray count]-1) ) {
        
        // Load more data from CoreData
        [self performAPIRequestForMoreEntries];

    }
}

@end