//
//  VideoCardController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardController.h"
#import "CoreDataUtility.h"
#import "ShelbyAPIClient.h"
#import "SocialFacade.h"
#import "CommentViewController.h"
#import "RollItViewController.h"
#import "ShareViewController.h"
#import "NSString+TypedefConversion.h"

@interface VideoCardController ()

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) Frame *frame;

@end

@implementation VideoCardController
@synthesize frame = _frame;

#pragma mark - Initialization Method
- (id)initWithFrame:(Frame*)frame
{
    if ( self = [super init] ) {
        
        self.frame = frame;
        self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)upvote
{
    NSString *upvoteRequestString = [NSString stringWithFormat:APIRequest_PostUpvote, self.frame.frameID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *upvoteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:upvoteRequestString]];
    [upvoteRequest setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:upvoteRequest ofType:APIRequestType_PostUpvote];
}

- (void)downvote
{
    NSString *downvoteRequestString = [NSString stringWithFormat:APIRequest_PostDownvote, self.frame.frameID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *downvoteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downvoteRequestString]];
    [downvoteRequest setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:downvoteRequest ofType:APIRequestType_PostDownvote];
}

- (void)comment
{
    CommentViewController *commentViewController = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil andFrame:self.frame];
    [self.appDelegate.menuController.navigationController pushViewController:commentViewController animated:YES];
    [self.appDelegate.menuController.navigationController setNavigationBarHidden:NO];
}

- (void)roll
{
    RollItViewController *rollItViewController = [[RollItViewController alloc] initWithNibName:@"RollItViewController" bundle:nil andFrame:self.frame];
    [self.appDelegate.menuController.navigationController pushViewController:rollItViewController animated:YES];
    [self.appDelegate.menuController.navigationController setNavigationBarHidden:NO];
}

- (void)share
{
    ShareViewController *shareViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil andFrame:self.frame];
    [self.appDelegate.menuController.navigationController pushViewController:shareViewController animated:YES];
    [self.appDelegate.menuController.navigationController setNavigationBarHidden:NO];
}

@end