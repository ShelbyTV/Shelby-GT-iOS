//
//  StreamTableViewManager.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StreamTableViewManager.h"
#import "GuideTableViewController.h"
#import "VideoCardController.h"
#import "VideoPlayerViewController.h"

@interface StreamTableViewManager () <VideoCardDelegate>

@property (assign, nonatomic) BOOL observerCreated;
@property (assign, nonatomic) BOOL didPullToRefresh;;

- (void)createAPIObservers;

@end

@implementation StreamTableViewManager 
@synthesize observerCreated = _observerCreated;
@synthesize didPullToRefresh = _didPullToRefresh;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[NSString requestTypeToString:APIRequestType_GetStream]
                                                  object:nil];
}


#pragma mark - Private Methods
- (void)createAPIObservers
{
    
    NSString *notificationName = [NSString requestTypeToString:APIRequestType_GetStream];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(dataReturnedFromAPI:) 
                                                 name:notificationName 
                                               object:nil];
    self.observerCreated = YES;
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
    // Fetch Rolls-Following Data from Core Data
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) {
        
        self.coreDataResultsArray = [CoreDataUtility fetchAllDashboardEntries];
        
        if ( [self.coreDataResultsArray count] > 0) {
         
            [self.tableView reloadData];
            
        } else {
            
            [self performAPIRequest];
            
        }
        
    }
    
    [self.guideController.appDelegate removeHUD];
    
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
    NSUInteger skipCount = (([self.coreDataResultsArray count]/20)+1)*20;
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetStreamAgain, [SocialFacade sharedInstance].shelbyToken, skipCount];
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
    [self setDidPullToRefresh:YES];
    [self performAPIRequest];
}

#pragma mark - UITableViewDatasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     Since heightForRowAtIndexPath is called before cellForRowAtIndexPath (e.g., no cells are drawn),
     I need to use a discriminating value to figure out how to draw the cells. The vallue that discriminates between 
     VideoCardCell and VideoCardExpandedCell is the upvotersCount. Therefore, I've employed the method below to 
     calclate the height.
     */
    
    // Fetch data stored in Core Data
    DashboardEntry *dashboardEntry = [self.coreDataResultsArray objectAtIndex:indexPath.row];
    
    // Create proper cell based on number of upvotes
    NSUInteger upvotersCount = [dashboardEntry.frame.upvotersCount intValue];

    if ( upvotersCount ) {
        
        return 246.0f;
        
    } else {
        
        return 214.0f;
    }
    
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
        VideoCardExpandedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if ( nil == cell ) cell = (VideoCardExpandedCell*)[nib objectAtIndex:0];
        
        
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
                
                if ( dashboardEntry.frame != nil ) [self populateTableViewCell:cell withDashboardContent:dashboardEntry inRow:indexPath.row];
                
            }
        }
        
        return cell;
        
    } else {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCardCell" owner:self options:nil];
        VideoCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if ( nil == cell ) cell = (VideoCardCell*)[nib objectAtIndex:0];
    
        // Pseudo-hide cell until it's populated with information
        [cell setAlpha:0.0f];
        
        if ( [self.coreDataResultsArray count]  ) {
            
            if ( [self.coreDataResultsArray objectAtIndex:indexPath.row] ) {
                
                [self populateTableViewCell:cell withDashboardContent:dashboardEntry inRow:indexPath.row];
                
            }
        }
        
        return cell;
        
    }
    
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCardCell *cell = (VideoCardCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    VideoPlayerViewController *videoPlayerViewController = [[VideoPlayerViewController alloc] initWithFrame:cell.shelbyFrame];
    [self.guideController.appDelegate.menuController.navigationController presentModalViewController:videoPlayerViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSUInteger resultsCount = [self.coreDataResultsArray count];
    
    if ( (indexPath.row == (resultsCount-1)) && (resultsCount > TextConstants_SwipeUpToRefreshMinimum) ) {
        
        // Load more data from CoreData
        [self performAPIRequestForMoreEntries];
        
        [self.guideController.appDelegate addHUDWithMessage:@"Fetching older videos..."];

    }
}


#pragma mark - VideoCardDelegate Methods
- (void)populateTableViewCell:(VideoCardCell *)cell withDashboardContent:(DashboardEntry *)dashboardEntry inRow:(NSUInteger)row
{
    
    // General Initializations
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Add reference to video's frame
        cell.shelbyFrame = dashboardEntry.frame;
        
        // Initialize VideoCardController
        VideoCardController *videoCardController = [[VideoCardController alloc] initWithShelbyFrame:cell.shelbyFrame
                                                                        andGuideTableViewController:self.guideController];
        
        // Add reference to VideoCardController
        cell.videoCardController = videoCardController;
        
        // Add reference to GuideTableViewController
        cell.guideController = self.guideController;
        
        // Populate roll label
        [cell.rollLabel setText:dashboardEntry.frame.roll.title];
        
        // Populate nickname label
        [cell.videoTitleLabel setText:dashboardEntry.frame.video.title];
        
        // Connect Comment Button
        [cell.commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        
        // Connect Roll Button
        [cell.rollButton addTarget:self action:@selector(roll:) forControlEvents:UIControlEventTouchUpInside];
        
        // Connect Share Button
        [cell.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        
        // Connect Heart/Unheart button (depends if user already liked video)
        BOOL upvoted = [CoreDataUtility checkIfUser:[SocialFacade sharedInstance].shelbyCreatorID upvotedInFrame:dashboardEntry.frame];
        
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
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    [cell.videoCardController upvote:button];
}

- (void)downvote:(UIButton *)button
{
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    [cell.videoCardController downvote:button];
}

- (void)comment:(UIButton *)button
{
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    [cell.videoCardController comment];
}

- (void)roll:(UIButton *)button
{
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    [cell.videoCardController roll];
}

- (void)share:(UIButton *)button
{
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    [cell.videoCardController share];
}

@end