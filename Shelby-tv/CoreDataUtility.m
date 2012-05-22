//
//  CoreDataUtility.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CoreDataUtility.h"
#import "NSString+CoreData.h"

@interface CoreDataUtility ()
{
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;     
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

// Store dashboardEntry data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forDashboardEntryInContext:(NSManagedObjectContext*)context;

// Store roll data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forRollInContext:(NSManagedObjectContext*)context;

// Store dashbaordEntry.frame data in Core Data
+ (void)storeFrameArray:(NSArray*)frameArray forDashboardEntry:(DashboardEntry*)dashboardEntry inContext:(NSManagedObjectContext*)context;

@end

@implementation CoreDataUtility
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static CoreDataUtility *sharedInstance = nil;

#pragma mark - Singleton Methods
+ (CoreDataUtility*)sharedInstance
{
    if ( nil == sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Public Methods
+ (void)storeParsedData:(NSDictionary *)parsedDictionary inCoreData:(NSManagedObjectContext *)context ForType:(APIRequestType)requestType
{
    if ( requestType == APIRequestTypeStream ) {
        
        [self storeParsedData:parsedDictionary forDashboardEntryInContext:context];
            
    } else if ( requestType == APIRequestTypeRolls ) {
        
        [self storeParsedData:parsedDictionary forRollInContext:context];
        
    } else {
        
        // Other types (temporary for now)
        
    }
        
}

+ (DashboardEntry*)fetchDashboardEntryData:(NSManagedObjectContext *)context forRow:(NSUInteger)row
{
 
    // Create Fetch Request
    NSFetchRequest *dashboardEntryRequest = [[NSFetchRequest alloc] init];
    
    // Fetch DashboardEntry Data
    NSEntityDescription *dashboardEntryDescription = [NSEntityDescription entityForName:kCoreDataDashboardEntry inManagedObjectContext:context];
    [dashboardEntryRequest setEntity:dashboardEntryDescription];
    
    // Sort by Timestamp
    NSSortDescriptor *timestampSorter = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [dashboardEntryRequest setSortDescriptors:[NSArray arrayWithObject:timestampSorter]];
    
    // Execute Request that returns array of dashboardEntrys
    NSArray *dashboardEntryArray = [context executeFetchRequest:dashboardEntryRequest error:nil];
    
    // Return dashbaordEntry at a specific index
    return [dashboardEntryArray objectAtIndex:row];
}

+ (void)saveContext:(NSManagedObjectContext *)context
{

    NSError *error = nil;    
    if ( context ) {
        
        if ( [context hasChanges] && ![context save:&error] ) {
            if (DEBUGMODE) NSLog(@"Could not save changes to Core Data. Error: %@, %@", error, [error userInfo]);
        } else {
            if (DEBUGMODE) NSLog(@"Successfully saved changes to Core Data");
        }
    }
}

#pragma mark - Private Methods
+ (void)storeParsedData:(NSDictionary *)parsedDictionary forDashboardEntryInContext:(NSManagedObjectContext *)context
{
 
    NSArray *resultsArray = [parsedDictionary objectForKey:kAPIResult];
    
    for (NSUInteger i = 0; i < [resultsArray count]; i++ ) {
        
        // Store dashboardEntry attirubutes
        
        DashboardEntry *dashboardEntry = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataDashboardEntry inManagedObjectContext:context];
        NSString *dashboardID = [NSString testForNullForCoreDataAttribute:[[resultsArray objectAtIndex:i] valueForKey:@"id"]];
        [dashboardEntry setValue:dashboardID forKey:@"dashboardID"];
        
        // Store dashboardEntry.frame attributes
        NSArray *frameArray = [[resultsArray objectAtIndex:i] valueForKey:@"frame"];
        [self storeFrameArray:frameArray forDashboardEntry:dashboardEntry inContext:context];
        
    }
    
    // Commity unsaved data in context
    [self saveContext:context];

    
}

+ (void)storeParsedData:(NSDictionary *)parsedDictionary forRollInContext:(NSManagedObjectContext *)context
{
    
}

+ (void)storeFrameArray:(NSArray *)frameArray forDashboardEntry:(DashboardEntry *)dashboardEntry inContext:(NSManagedObjectContext *)context
{
    
    // Store dashboard.frame attributes
    Frame *frame = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataFrame inManagedObjectContext:context];
    dashboardEntry.frame = frame;
    
    NSString *frameID = [NSString testForNullForCoreDataAttribute:[frameArray valueForKey:@"id"]];
    [frame setValue:frameID forKey:@"frameID"];
    
    NSString *frameConversationID = [NSString testForNullForCoreDataAttribute:[frameArray valueForKey:@"conversation_id"]];
    [frame setValue:frameConversationID forKey:@"conversationID"];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+00:00"];
    NSDate *timestamp = [dateFormat dateFromString:[frameArray valueForKey:@"timestamp"]];
    [frame setValue:timestamp forKey:@"timestamp"];
    [dashboardEntry setValue:timestamp forKey:@"timestamp"];
    
    NSString *frameUserID = [NSString testForNullForCoreDataAttribute:[frameArray valueForKey:@"creator_id"]];
    [frame setValue:frameUserID forKey:@"userID"];
    
    NSString *frameVideoID = [NSString testForNullForCoreDataAttribute:[frameArray valueForKey:@"video_id"]];
    [frame setValue:frameVideoID forKey:@"videoID"];
    
    // Store dashboard.frame.conversation attributes
    
    // Store dashboard.frame.user attributes
    User *user = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataUser inManagedObjectContext:context];
    frame.user = user;
    
    NSArray *userArray = [frameArray valueForKey:@"creator"];
    
    NSString *userID = [NSString testForNullForCoreDataAttribute:[userArray valueForKey:@"creator_id"]];
    [user setValue:userID forKey:@"userID"];
    
    // Store dashboard.frame.video attributes
    Video *video = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataVideo inManagedObjectContext:context];
    frame.video = video;
    
    NSArray *videoArray = [frameArray valueForKey:@"video"];
    
    NSString *videoID = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"video_id"]];
    [video setValue:videoID forKey:@"videoID"];
    
    NSString *videoCaption = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"description"]];
    [video setValue:videoCaption forKey:@"caption"];
    
    NSString *videoProviderName = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"provider_name"] ];
    [video setValue:videoProviderName forKey:@"providerName"];
    
    NSString *videoSourceURL = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"source_url"]];
    [video setValue:videoSourceURL forKey:@"sourceURL"];
    
    NSString *videoThumbnailURL = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"thumbnail_url"]];
    [video setValue:videoThumbnailURL forKey:@"thumbnailURL"];
    
    NSString *videoTitle = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"title"]];
    [video setValue:videoTitle forKey:@"title"];

}

#pragma mark - Accessor Methods
/*
 
 Returns the application's instance of NSManagedObjectConteext.
 If an instance doesn't exist, it's created and bound to the application's instance of NSPersistentStoreCoordinator.
 
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if ( _managedObjectContext ) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if ( coordinator ){
        
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setUndoManager:nil];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [_managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        
    }
    
    return _managedObjectContext;
}

/*
 
 Returns the application's instance of NSManagedObjectModel.
 If an instance of the model doesn't exist, it is created from the application's model.
 
 */
- (NSManagedObjectModel *)managedObjectModel
{
    
    if ( _managedObjectModel ) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
    
}

/*
 
 Returns the application's instance NSPersistentStoreCoordinator.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if ( _persistentStoreCoordinator ) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"Shelby-tv.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if ( ![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error] )
    {
        // Delete datastore if there's a conflict. User can re-login to repopulate the datastore.
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        // Retry
        if ( ![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error] )
        {
           if (DEBUGMODE) NSLog(@"Could not save changes to Core Data. Error: %@, %@", error, [error userInfo]);
        }
    }
    
    return _persistentStoreCoordinator;
}

@end