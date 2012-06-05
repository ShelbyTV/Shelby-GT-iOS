//
//  ShelbyAPIClient.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/2/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyAPIClient.h"
#import "CoreDataUtility.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "NSString+TypedefConversion.h"

@interface ShelbyAPIClient ()

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSDictionary *parsedDictionary;
@property (assign, nonatomic) APIRequestType requestType;

- (NSDictionary*)parseData;

@end

@implementation ShelbyAPIClient
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
@synthesize parsedDictionary = parsedDictionary;
@synthesize requestType = _requestType;

#pragma mark - Public Methods
- (void)performRequest:(NSMutableURLRequest *)request ofType:(APIRequestType)type
{
    // Set Request Type
    self.requestType = type;
    
    // Initialize Request
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - Private Methods
- (NSDictionary*)parseData
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    return [parser objectWithData:self.receivedData];
}

#pragma mark - NSURLConnectionDataDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
    if ( connection == self.connection ) {
        
        self.receivedData = [[NSMutableData alloc] init];

    } else {
        
        NSLog(@"CONNECTION FAILED!");
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
        
        NSLog(@"CONNECTION ERROR!");
        
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Parse Data with SBJSON Parser
    self.parsedDictionary = [self parseData];
    
    switch (self.requestType) {
            
        case APIRequestTypePostTwitter:{
            
            NSString *notificationName = [NSString apiRequestTypeToString:self.requestType];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:parsedDictionary];
        
        } break;
        
        case APIRequestTypeGetStream:{
            
            // Store parsedDictionary in Core Data
            NSManagedObjectContext *context = [CoreDataUtility sharedInstance].managedObjectContext;
            [CoreDataUtility storeParsedData:self.parsedDictionary inCoreData:context ForType:self.requestType];
            
        } break;
            
        default:
            break;
   
    }
    
    // Reset Request Type
    self.requestType = APIRequestTypeNone;
}

@end