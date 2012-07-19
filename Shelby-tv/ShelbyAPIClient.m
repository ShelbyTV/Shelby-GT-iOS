//
//  ShelbyAPIClient.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/2/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyAPIClient.h"
#import "CoreDataUtility.h"
#import "SocialFacade.h"
#import "AppDelegate.h"
#import "NSString+TypedefConversion.h"
#import "Reachability.h"

@interface ShelbyAPIClient ()

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSDictionary *parsedDictionary;
@property (assign, nonatomic) APIRequestType requestType;

- (void)postNotification;

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
    
    // Initialize Reachability
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    [reach startNotifier];
    
    // If internet connection is AVAILABLE, execute this block of code.
    reach.reachableBlock = ^(Reachability *reach){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ( DEBUGMODE ) NSLog(@"Internet Connection Available");
            
            // Initialize Request
            self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            // Show statusBar activity Indicator
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            
        });

    };
    
    // If internet connection is UNAVAILABLE, execute this block of code.
    reach.unreachableBlock = ^(Reachability *reach){
        
    if ( DEBUGMODE ) NSLog(@"Internet Connection Unavailable");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Post notification to force UI changes, like pull-to-refresh to finish
            [self postNotification];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Internet Connection Unavailable"
                                                                message:@"Please make sure you're connected to WiFi or 3G and try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
            
        });

    };
    

}

- (void)postNotification
{
    NSString *notificationName = [NSString requestTypeToString:self.requestType];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:self.parsedDictionary];
}

#pragma mark - NSURLConnectionDataDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
    if ( connection == self.connection ) {
        
        self.receivedData = [[NSMutableData alloc] init];

    } else {
        
       if ( DEBUGMODE ) NSLog(@"CONNECTION FAILED!");
        
        // Remove HUD
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate removeHUD];
        
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
                                                            message:@"Please retry your previous action"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        
        // Remove HUD
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate removeHUD];
        
        // Post notification for specific requestTypes
        switch (self.requestType) {
                
            case APIRequestType_PostToken:{
                // Do Nothing
            } break;
                
            default:{
                [self postNotification];
            }
                break;
        }

        // Reset request type
        self.requestType = APIRequestType_None;
        
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    // Reference App Delegate
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
 
    // Hide statusBar activity indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Create reference to context
    NSManagedObjectContext *context = [CoreDataUtility sharedInstance].managedObjectContext;
    
    self.parsedDictionary = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingAllowFragments error:nil];
    
    switch ( self.requestType ) {
            
        case APIRequestType_PostToken:{
            
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];

        } break;
        
        case APIRequestType_GetStream:{
            
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];
            
        } break;
       
        case APIRequestType_GetRollsFollowing:{
            
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];
            
        } break;
            
        case APIRequestType_GetExploreRolls:{
            
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];
            
        } break;
            
        case APIRequestType_GetRollFrames:{
            
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];
            
        } break;
            
        case APIRequestType_PostUpvote:{
            
            if ( DEBUGMODE ) NSLog(@"Upvoted posted successfully");
            
        } break;
            
        
        case APIRequestType_PostDownvote:{
            
            if ( DEBUGMODE ) NSLog(@"Downvote posted successfully");
            
        } break;

        case APIRequestType_PostShareFrame:{
            
            [appDelegate removeHUD];
            
        } break;
           
        case APIRequestType_PostRollFrame:{
        
            [appDelegate removeHUD];
            
        } break;
            
        case APIRequestType_PostMessage:{
            
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context forType:self.requestType];
            
        } break;
            
        default:
            break;
   
    }
    
    // Reset request type
    self.requestType = APIRequestType_None;
}

@end