//
//  StreamTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StreamTableViewManager.h"
#import "VideoCardController.h"
#import "AsynchronousFreeloader.h"

@interface StreamTableViewManager ()

@property (assign, nonatomic) BOOL observerCreated;
@property (strong, nonatomic) NSMutableArray *arrayOfCells;
@property (strong, nonatomic) NSMutableArray *arrayOfFrameIDs;

- (void)createAPIObservers;
- (void)populateTableViewCell:(VideoCardCell*)cell withContentForRow:(NSUInteger)row;
- (void)animateCell:(VideoCardCell*)cell forRow:(NSUInteger)row;

- (void)upvote:(UIButton *)button;
- (void)downvote:(UIButton *)button;

@end

@implementation StreamTableViewManager 
@synthesize observerCreated = _observerCreated;
@synthesize arrayOfCells = _arrayOfCells;
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

- (void)populateTableViewCell:(VideoCardCell *)cell withContentForRow:(NSUInteger)row
{

        // General Initializations
        [cell setTag:row];
        [cell.upvoteButton setTag:row];
        [cell.upvoteLabel setTag:row];
        
        if ( ![self arrayOfCells] ) self.arrayOfCells = [NSMutableArray array];
        [self.arrayOfCells addObject:cell];
        
        // Fetch data stored in Core Data
        DashboardEntry *dashboardEntry = [self.coreDataResultsArray objectAtIndex:row];
        
        // Store Frame ID
        if ( ![self arrayOfFrameIDs] ) self.arrayOfFrameIDs = [NSMutableArray array];
        [self.arrayOfFrameIDs addObject:dashboardEntry.frame.frameID];
        
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
            
        // Present Facebook/Twitter/Tumblr icon for social network source of video
        if ( [message.originNetwork isEqualToString:@"facebook"] ) {
        
            [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampFacebook"]];
       
        } else if ( [message.originNetwork isEqualToString:@"twitter"] ) {
        
            [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampTwitter"]];
            
        } else if ( [message.originNetwork isEqualToString:@"tumblr"] ) {
            
            [cell.originNetworkImageView setImage:[UIImage imageNamed:@"videoCardTimestampTumblr"]];
            
        } else {
            
            // Do nothing for nil state
        }
        
        
        // Present Heart/Unheart button (depends if user already liked video)
        BOOL upvoted = [CoreDataUtility checkIfUserUpvotedInFrame:dashboardEntry.frame];

        if ( upvoted ) { // Make sure Heart is Red and user is able to Downvote
    
            [cell.upvoteButton setImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateNormal];
            [cell.upvoteButton setImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateHighlighted];
            [cell.upvoteButton addTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
            
        } else { // Make sure Heart is Gray and user is able to Upvote
    
            [cell.upvoteButton setImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateNormal];
            [cell.upvoteButton setImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateHighlighted];
            [cell.upvoteButton addTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
        }
    
        
        // Asychronous download of user image/icon
        if ( dashboardEntry.frame.creator.userImage ) {
            
            [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.creator.userImage forImageView:cell.userImageView withPlaceholderView:nil];
        
        } 

        // Asynchronous download of video thumbnail
        [AsynchronousFreeloader loadImageFromLink:dashboardEntry.frame.video.thumbnailURL forImageView:cell.thumbnailImageView withPlaceholderView:nil];

        
}

- (void)upvote:(UIButton *)button
{
    if ( DEBUGMODE )NSLog(@"Upvote row %d with value: %@", button.tag, [self.arrayOfFrameIDs objectAtIndex:button.tag]);
    
    [button setImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateHighlighted];
    [button removeTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
    
    VideoCardCell *cell = (VideoCardCell*)[self.arrayOfCells objectAtIndex:button.tag];
    NSInteger numberOfVotes = [cell.upvoteLabel.text intValue];
    numberOfVotes++;
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.upvoteLabel setText:[NSString stringWithFormat:@"%d", numberOfVotes]];
        [cell setNeedsDisplay];
    });
    
    VideoCardController *controller = [[VideoCardController alloc] initWithFrameID:[self.arrayOfFrameIDs objectAtIndex:button.tag]];
    [controller upvote];
    
}

- (void)downvote:(UIButton *)button
{
    if ( DEBUGMODE ) NSLog(@"Downvote row %d with value: %@", button.tag, [self.arrayOfFrameIDs objectAtIndex:button.tag]);
    
    [button setImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateHighlighted];
    [button removeTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
    
    VideoCardCell *cell = (VideoCardCell*)[self.arrayOfCells objectAtIndex:button.tag];
    NSInteger numberOfVotes = [cell.upvoteLabel.text intValue];
    numberOfVotes--;
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.upvoteLabel setText:[NSString stringWithFormat:@"%d", numberOfVotes]];
            [cell setNeedsDisplay];
        });
    
    VideoCardController *controller = [[VideoCardController alloc] initWithFrameID:[self.arrayOfFrameIDs objectAtIndex:button.tag]];
    [controller downvote];
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
    
//    if ( (nil == cell) || (0 == indexPath.row) ) { // The 0 == indexPath.row is to fix an issue when reloading stream via the ShelbyMenuView
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCardCell" owner:self options:nil];
        cell = (VideoCardCell*)[nib objectAtIndex:0];
//    }
    
    // Pseudo-hide cell until it's populated with information
    [cell setAlpha:0.0f];
    
    // Populate UITableView row with content if content exists (CHANGE THIS CONDITION TO BE CORE-DATA DEPENDENT)
    if ( [self.coreDataResultsArray count]  ) {
     
        if ( [self.coreDataResultsArray objectAtIndex:indexPath.row] ) {
        
            [self populateTableViewCell:cell withContentForRow:indexPath.row];
            
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