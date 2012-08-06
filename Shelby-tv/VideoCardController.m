//
//  VideoCardController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardController.h"

// Controllers
#import "CoreDataUtility.h"
#import "ShelbyAPIClient.h"
#import "SocialFacade.h"

// View Controllers
#import "GuideTableViewController.h"
#import "CommentViewController.h"
#import "RollItViewController.h"
#import "ShareViewController.h"

// Views
#import "VideoCardCell.h"
#import "VideoCardExpandedCell.h"

// Cateogires
#import "NSString+TypedefConversion.h"

@interface VideoCardController ()

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) GuideTableViewController *guideController;
@property (strong, nonatomic) Frame *shelbyFrame;

@end

@implementation VideoCardController
@synthesize appDelegate = _appDelegate;
@synthesize shelbyFrame = _shelbyFrame;

#pragma mark - Initialization Method
- (id)initWithShelbyFrame:(Frame*)frame andGuideTableViewController:(GuideTableViewController *)guideController
{
    if ( self = [super init] ) {
        
        self.shelbyFrame = frame;
        self.guideController = guideController;
        self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)upvote:(UIButton*)button
{
    
    [[Panhandler sharedInstance] recordEvent];
    
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    Frame *frame = cell.shelbyFrame;
    
    // Grab reference to dashboardEntry and frame
    ShelbyUser *shelbyUser = [CoreDataUtility fetchShelbyAuthData];
    
    // Increase upvoteCount by 1
    NSUInteger upvoteCount = [button.titleLabel.text intValue];
    upvoteCount++;
    frame.upvotersCount = [NSNumber numberWithInt:upvoteCount];
    
    // Change button state
    dispatch_async(dispatch_get_main_queue(), ^{
        [button setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateHighlighted];
        [button removeTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%d", upvoteCount] forState:UIControlStateNormal];
    });
    
    // Store changes in Core Data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UpvoteUsers *upvoteUsers = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityUpvoteUsers inManagedObjectContext:frame.managedObjectContext];
        [upvoteUsers setValue:shelbyUser.shelbyID forKey:CoreDataUpvoteUserID];
        [upvoteUsers setValue:shelbyUser.nickname forKey:CoreDataUpvoteUsersNickname];
        [upvoteUsers setValue:shelbyUser.userImage forKey:CoreDataUpvoteUsersImage];
        [upvoteUsers setValue:frame.rollID forKey:CoreDataUpvoteUsersRollID];
        [frame addUpvoteUsersObject:upvoteUsers];
        [frame setValue:[NSNumber numberWithInt:upvoteCount] forKey:CoreDataFrameUpvotersCount];
        
        [CoreDataUtility saveContext:frame.managedObjectContext];
        
    });
    
    NSString *upvoteRequestString = [NSString stringWithFormat:APIRequest_PostUpvote, self.shelbyFrame.frameID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *upvoteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:upvoteRequestString]];
    [upvoteRequest setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:upvoteRequest ofType:APIRequestType_PostUpvote];
    
    // Add image through reload
    UITableView *tableView = (UITableView *)[cell superview];
    [tableView reloadRowsAtIndexPaths:tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationMiddle];
    [[tableView superview] setNeedsDisplay];
}

- (void)downvote:(UIButton*)button
{
    
    [[Panhandler sharedInstance] recordEvent];
    VideoCardCell *cell = (VideoCardCell*)[button superview];
    
    // Decrease upvoteCount by 1
    NSUInteger upvoteCount = [button.titleLabel.text intValue];
    upvoteCount--;
    self.shelbyFrame.upvotersCount = [NSNumber numberWithInt:upvoteCount];
    
    // Change button state
    dispatch_async(dispatch_get_main_queue(), ^{
        [button setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOff"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"videoCardButtonUpvoteOn"] forState:UIControlStateHighlighted];
        [button removeTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%d", upvoteCount] forState:UIControlStateNormal];
    });
    
    // Store changes in Core Data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSMutableSet *upvoteUsers = [NSMutableSet setWithSet:self.shelbyFrame.upvoteUsers];
        
        for (UpvoteUsers *user in [upvoteUsers allObjects]) {
            
            if ( [user.upvoterID isEqualToString:[SocialFacade sharedInstance].shelbyCreatorID] ) {
                
                [self.shelbyFrame removeUpvoteUsersObject:user];
                
            }
            
            [self.shelbyFrame setValue:[NSNumber numberWithInt:upvoteCount] forKey:CoreDataFrameUpvotersCount];
            
            [CoreDataUtility saveContext:self.shelbyFrame.managedObjectContext];
        }
    });
    
    NSString *downvoteRequestString = [NSString stringWithFormat:APIRequest_PostDownvote, self.shelbyFrame.frameID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *downvoteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downvoteRequestString]];
    [downvoteRequest setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:downvoteRequest ofType:APIRequestType_PostDownvote];
    
    // Remove image through reload
    UITableView *tableView = (UITableView *)[cell superview];
    [tableView reloadRowsAtIndexPaths:tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationMiddle];
    [[tableView superview] setNeedsDisplay];
}

- (void)comment
{
    [[Panhandler sharedInstance] recordEvent];
    CommentViewController *commentViewController = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil andFrame:self.shelbyFrame];
    [self.guideController.navigationController pushViewController:commentViewController animated:YES];
}

- (void)roll
{
    [[Panhandler sharedInstance] recordEvent];
    RollItViewController *rollItViewController = [[RollItViewController alloc] initWithNibName:@"RollItViewController" bundle:nil andFrame:self.shelbyFrame];
    [self.guideController.navigationController pushViewController:rollItViewController animated:YES];
}

- (void)share
{
    [[Panhandler sharedInstance] recordEvent];
    ShareViewController *shareViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil andFrame:self.shelbyFrame];
    [self.guideController.navigationController pushViewController:shareViewController animated:YES];
}

@end