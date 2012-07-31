//
//  RollFramesTableViewManager.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/21/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "RollFramesTableViewManager.h"
#import "GuideTableViewController.h"
#import "VideoCardController.h"
#import "VideoPlayerViewController.h"

@interface RollFramesTableViewManager () <VideoCardDelegate>

@property (assign, nonatomic) BOOL observerCreated;

- (void)createAPIObservers;

@end

@implementation RollFramesTableViewManager
@synthesize rollID = _rollID;
@synthesize observerCreated = _observerCreated;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[NSString requestTypeToString:APIRequestType_GetRollFrames]
                                                  object:nil];
}

#pragma mark - Private Methods
- (void)createAPIObservers
{
    
    NSString *notificationName = [NSString requestTypeToString:APIRequestType_GetRollFrames];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReturnedFromAPI:)
                                                 name:notificationName
                                               object:nil];
    self.observerCreated = YES;
}

#pragma mark - GuideTableViewMangerDelegate Methods
- (void)loadDataOnInitializationForTableView:(UITableView*)tableView andRollID:(NSString *)rollID
{
    // Reference Parent ViewController's UITableView (should ONLY occur on first call to this method)
    self.tableView = tableView;
    
    self.rollID = rollID;
    
    // Load stored data into tableView
    [self loadDataFromCoreData];
    
}

- (void)loadDataFromCoreData
{
    // Fetch Rolls-Following Data from Core Data
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) {
        
        self.coreDataResultsArray = [CoreDataUtility fetchFramesForRoll:self.rollID];
    
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
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetRollFrames, self.rollID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_GetRollFrames];
}

- (void)performAPIRequestForMoreEntries
{
    
    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Perform API Request
    NSUInteger skipCount = (([self.coreDataResultsArray count]/20)+1)*20;
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetRollsFollowingAgain, self.rollID, [SocialFacade sharedInstance].shelbyToken, skipCount];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_GetRollFrames];
    
}

- (void)performAPIRequestForRollID:(NSString *)rollID
{
    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Grab reference to rollID
    self.rollID = rollID;
    
    // Perform API Request
    NSString *requestString = [NSString stringWithFormat:APIRequest_GetRollFrames, self.rollID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_GetRollFrames];
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
    return 243.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( self.coreDataResultsArray ) ?  [self.coreDataResultsArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch ( [self.coreDataResultsArray count] ) {
        case 0:{
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.alpha = 0.0f;
            return cell;
            
        } break;
            
        default:{
            
            // Fetch data stored in Core Data
            Frame *frame = [self.coreDataResultsArray objectAtIndex:indexPath.row];
            
            // Create proper cell based on number of upvotes
            NSUInteger upvotersCount = [frame.upvotersCount intValue];
            
            if ( upvotersCount > 0 ) {
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCardExpandedCell" owner:self options:nil];
                VideoCardExpandedCell *cell = (VideoCardExpandedCell*)[nib objectAtIndex:0];
                
                NSUInteger userCounter = 0;
                NSMutableArray *upvoteUsersarray = [NSMutableArray arrayWithArray:[frame.upvoteUsers allObjects]];
                
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
                        
                        [self populateTableViewCell:cell withFrameContent:frame inRow:indexPath.row];
                        
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
                        
                        [self populateTableViewCell:cell withFrameContent:frame inRow:indexPath.row];
                        
                    }
                }
                
                return cell;
                
            }
            
            
        } break;
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
- (void)populateTableViewCell:(VideoCardCell *)cell withFrameContent:(Frame *)frame inRow:(NSUInteger)row
{
    
    // General Initializations
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Reference video frame
        cell.shelbyFrame = frame;
        
        // Populate roll label
        [cell.rollLabel setText:frame.roll.title];
        
        // Populate nickname label
        [cell.nicknameLabel setText:frame.creator.nickname];
        
        // Connect Comment Button
        [cell.commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        
        // Connect Roll Button
        [cell.rollButton addTarget:self action:@selector(roll:) forControlEvents:UIControlEventTouchUpInside];
        
        // Connect Share Button
        [cell.shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        
        // Connect Heart/Unheart button (depends if user already liked video)
        BOOL upvoted = [CoreDataUtility checkIfUserUpvotedInFrame:frame];
        
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
        [cell.upvoteButton setTitle:[NSString stringWithFormat:@"%@", frame.upvotersCount] forState:UIControlStateNormal];
        
        // Populate comments label
        [cell.commentButton setTitle:[NSString stringWithFormat:@"%@", frame.conversation.messageCount] forState:UIControlStateNormal];
        
        // Fetch messages specific to dashboardEntry (may return nil, but that's ok!)
        Messages *message = [CoreDataUtility fetchFirstMessageFromConversation:frame.conversation];
        
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
        if ( frame.creator.userImage ) {
            
            [AsynchronousFreeloader loadImageFromLink:frame.creator.userImage forImageView:cell.userImageView withPlaceholderView:nil];
            
        }
        
        // Asynchronous download of video thumbnail
        [AsynchronousFreeloader loadImageFromLink:frame.video.thumbnailURL forImageView:cell.thumbnailImageView withPlaceholderView:nil];
        
    });
    
}

- (void)upvote:(UIButton *)button
{
    
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    Frame *frame = cell.shelbyFrame;
    
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
            
            ShelbyUser *shelbyUser = [CoreDataUtility fetchShelbyAuthData];
            UpvoteUsers *upvoteUsers = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityUpvoteUsers inManagedObjectContext:frame.managedObjectContext];
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
    VideoCardController *controller = [[VideoCardController alloc] initWithFrame:frame];
    [controller upvote];
    
    
}

- (void)downvote:(UIButton *)button
{
    
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    Frame *frame = cell.shelbyFrame;
    
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
    VideoCardController *controller = [[VideoCardController alloc] initWithFrame:frame];
    [controller downvote];
}

- (void)comment:(UIButton *)button
{
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    VideoCardController *controller = [[VideoCardController alloc] initWithFrame:cell.shelbyFrame];
    [controller comment];
}

- (void)roll:(UIButton *)button
{
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    VideoCardController *controller = [[VideoCardController alloc] initWithFrame:cell.shelbyFrame];
    [controller roll];
}

- (void)share:(UIButton *)button
{
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    VideoCardController *controller = [[VideoCardController alloc] initWithFrame:cell.shelbyFrame];
    [controller share];
}

@end