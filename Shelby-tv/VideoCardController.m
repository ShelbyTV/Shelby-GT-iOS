//
//  VideoCardController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardController.h"
#import "CoreDataUtility.h"
#import "ShelbyAPIClient.h"
#import "SocialFacade.h"

@interface VideoCardController ()

@property (strong, nonatomic) NSString *frameID;

@end

@implementation VideoCardController
@synthesize frameID = _frameID;

- (id)initWithFrameID:(NSString *)frameID;
{
    if ( self == [super init] ) {
        
        self.frameID = frameID;
     
    }
    
    return self;
}

- (void)upvote
{
    NSString *upvoteRequestString = [NSString stringWithFormat:APIRequest_PostDownvote, self.frameID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *upvoteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:upvoteRequestString]];
    [upvoteRequest setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:upvoteRequest ofType:APIRequestTypePostUpvote];
    
}

- (void)downvote
{
    NSString *downvoteRequestString = [NSString stringWithFormat:APIRequest_PostDownvote, self.frameID, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *downvoteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downvoteRequestString]];
    [downvoteRequest setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:downvoteRequest ofType:APIRequestTypePostDownvote];
}

- (void)comment
{
    
}

- (void)roll
{
    
}

- (void)share
{
    
}

@end