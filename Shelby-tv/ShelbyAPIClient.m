//
//  ShelbyAPIClient.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/2/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyAPIClient.h"
#import "NSString+TypedefConversion.h"
#import "SBJson.h"

@interface ShelbyAPIClient ()

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSDictionary *parsedDictionary;
@property (assign, nonatomic) APIRequestType requestType;

- (void)reset;

@end

@implementation ShelbyAPIClient
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
@synthesize parsedDictionary = parsedDictionary;
@synthesize requestType = _requestType;

#pragma mark - Initialization
- (id)initWithRequest:(NSURLRequest *)request ofType:(APIRequestType)type
{
    if ( self == [super init] ) {
    
        // Reset Variables
        [self reset];
        
        // Set Request Type
        self.requestType = type;
        
        // Initialize Request
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

    }
    
    return self;
}

#pragma mark - Private Methods
- (void)reset
{
    self.requestType = APIRequestTypeNone;
    self.parsedDictionary = nil;
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
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    self.parsedDictionary = [parser objectWithData:self.receivedData];
    
    // Post Notification with Parsed Object
    NSString *notificationName = [NSString apiRequestTypeToString:self.requestType];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self.parsedDictionary];
}

@end