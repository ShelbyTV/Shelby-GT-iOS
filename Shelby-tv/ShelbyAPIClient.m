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
- (void)storeParsedDataInCoreDataOfType:(APIRequestType)requestType;

@end

@implementation ShelbyAPIClient
@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
@synthesize parsedDictionary = parsedDictionary;
@synthesize requestType = _requestType;

#pragma mark - Public Methods
- (void)performRequest:(NSURLRequest *)request ofType:(APIRequestType)type
{
    // Set Request Type
    self.requestType = type;
    
    // Initialize Request
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - Private Methods
- (NSDictionary*)parseData
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    return [parser objectWithData:self.receivedData];
}

- (void)storeParsedDataInCoreDataOfType:(APIRequestType)requestType
{
        
    CoreDataUtility *coreDataUtility = (CoreDataUtility*)[CoreDataUtility sharedInstance];

    NSLog(@"%@", coreDataUtility.managedObjectContext);    
//    NSManagedObjectContext *context = coreDataUtility.managedObjectContext;
//    
//    NSLog(@"%@", context);
    
//    if ( requestType == APIRequestTypeStream ) {
//    
//        NSManagedObject *dashboardEntry = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataDashboardEntry inManagedObjectContext:context];
//        NSArray *resultsArray = [self.parseData objectForKey:kAPIRequestResult];
//        
//        for (NSUInteger i = 0; i < [resultsArray count]; i++ ) {
//            
//            NSString *idString = [[resultsArray objectAtIndex:i] valueForKey:@"id"];
//            NSLog(@"%@", idString);
//            [dashboardEntry setValue:idString forKey:@"idString"];
//
//        }
//     
//     }
//    
//    [CoreDataUtility saveContext:context];

    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:kCoreDataDashboardEntry inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error = nil;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    
//    for (NSManagedObject *object in fetchedObjects) {
//        NSLog(@"ID: %@", [object valueForKey:@"id"]);
//    }
//    NSLog(@"---------------");
//    
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
    
    // Store Parsed Data in Core Data
    [self storeParsedDataInCoreDataOfType:self.requestType];
    
    // Post Notification with Parsed Object
    NSString *notificationName = [NSString apiRequestTypeToString:self.requestType];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:self.parsedDictionary];
}

@end