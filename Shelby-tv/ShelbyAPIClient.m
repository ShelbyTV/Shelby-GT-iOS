//
//  ShelbyAPIClient.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/2/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyAPIClient.h"
#import "CoreDataUtility.h"
#import "SocialFacade.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "NSString+TypedefConversion.h"

@interface ShelbyAPIClient ()

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSDictionary *parsedDictionary;
@property (assign, nonatomic) APIRequestType requestType;

- (NSDictionary*)parseData;
- (void)updateUpvoteState:(NSDictionary*)resultsDictionary;

@end

@implementation ShelbyAPIClient
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
@synthesize parsedDictionary = _parsedDictionary;
@synthesize requestType = _requestType;

#pragma mark - Public Methods
- (void)performRequest:(NSMutableURLRequest *)request ofType:(APIRequestType)type
{
    // Set Request Type
    self.requestType = type;
    
    // Initialize Request
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - Private Methods
- (NSDictionary*)parseData
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    return [parser objectWithData:self.receivedData];
}

- (void)updateUpvoteState:(NSDictionary*)resultsDictionary
{
    NSString *frameRequestString = [NSString stringWithFormat:APIRequest_GetStream, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *frameRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:frameRequestString]];
    [frameRequest setHTTPMethod:@"GET"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:frameRequest ofType:APIRequestType_UpdateUpvoteState];
}

#pragma mark - NSURLConnectionDataDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
    if ( connection == self.connection ) {
        
        self.receivedData = [[NSMutableData alloc] init];

    } else {
        
       if ( DEBUGMODE ) NSLog(@"CONNECTION FAILED!");
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    if ( connection == self.connection ) {
        
        [self.receivedData appendData:data];
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    if ( connection == self.connection ) {
        
        if ( DEBUGMODE ) NSLog(@"CONNECTION ERROR for APIRequestType #%d!", self.requestType);

        // Hide activity indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        
        // Pop request-dependent error message
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error #%d0", self.requestType]
                                                            message:@"Please retrty your previous action"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        
        // Post notification for specific requestTypes
        switch (self.requestType) {
                
            case APIRequestType_PostToken:{
                // Do Nothing
            } break;
                
            default:{
                NSString *notificationName = [NSString apiRequestTypeToString:self.requestType];
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:self.parsedDictionary];
            }
                break;
        }
        

        
        // Reset request type
        self.requestType = APIRequestType_None;
        
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
 
    // Hide activity indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.parsedDictionary = [self parseData];
    
    switch (self.requestType) {
            
        case APIRequestType_PostToken:{
            
            NSManagedObjectContext *context = [CoreDataUtility sharedInstance].managedObjectContext;
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];

        } break;
        
        case APIRequestType_GetStream:{
            
            NSManagedObjectContext *context = [CoreDataUtility sharedInstance].managedObjectContext;
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];
            
        } break;
            
        case APIRequestType_PostUpvote:{
            
            if ( DEBUGMODE ) NSLog(@"Upvoted posted successfully");
            
//            [self updateUpvoteState:self.parsedDictionary];
            
        } break;
            
        
        case APIRequestType_PostDownvote:{
            
            if ( DEBUGMODE ) NSLog(@"Downvote posted successfully");
//            [self updateUpvoteState:self.parsedDictionary];
            
        } break;
            
            
        case APIRequestType_UpdateUpvoteState:{
            
            NSManagedObjectContext *context = [CoreDataUtility sharedInstance].managedObjectContext;
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];
            
        } break;
            
        default:
            break;
   
    }
    
    // Reset request type
    self.requestType = APIRequestType_None;
}

@end