//
//  CoreDataUtility.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CoreDataUtility.h"
#import "NSString+CoreData.h"
#import "NSDate+DateFromBSONString.h"

@interface CoreDataUtility ()
{
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;     
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

// Store dashboardEntry data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forDashboardEntryInContext:(NSManagedObjectContext*)context;

// Store dashbaordEntry.frame data in Core Data
+ (void)storeFrame:(Frame*)frame fromFrameArray:(NSArray*)frameArray inContext:(NSManagedObjectContext*)context;

// Store dashboard.frame.conversations data in Core Data
+ (void)storeConversation:(Conversation*)conversation fromframeArray:(NSArray*)frameArray inContext:(NSManagedObjectContext*)context;

// Store dashboard.frame.conversations.messages data in Core Data
+ (void)storeMessagesFromConversation:(Conversation*)conversation withConversationsArray:(NSArray*)conversationsArray inContext:(NSManagedObjectContext*)context;

// Store roll data in Core Data
+ (void)storeRoll:(Roll*)roll fromFrameArray:(NSArray*)frameArray inContext:(NSManagedObjectContext*)context;

// Store dashboard.frame.user data in Core Data
+ (void)storeUser:(User*)user fromFrameArray:(NSArray*)frameArray inContext:(NSManagedObjectContext*)context;

// Store dashboard.frame.video data in Core Data
+ (void)storeVideo:(Video*)video fromFrameArray:(NSArray*)frameArray inContext:(NSManagedObjectContext*)context;

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
        
        
    } else {
        
        // Other types (temporary for now)
        
    }
        
}

+ (DashboardEntry*)fetchDashboardEntryData:(NSManagedObjectContext *)context forRow:(NSUInteger)row
{
 
    // Create fetch request
    NSFetchRequest *dashboardEntryRequest = [[NSFetchRequest alloc] init];
    [dashboardEntryRequest setReturnsObjectsAsFaults:NO];

    // Fetch dashboardEntry data
    NSEntityDescription *dashboardEntryDescription = [NSEntityDescription entityForName:kCoreDataDashboardEntry inManagedObjectContext:context];
    [dashboardEntryRequest setEntity:dashboardEntryDescription];
    
    // Sort by timestamp
    NSSortDescriptor *dashboardTimestampSorter = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [dashboardEntryRequest setSortDescriptors:[NSArray arrayWithObject:dashboardTimestampSorter]];
    
    // Execute request that returns array of dashboardEntrys
    NSArray *dashboardEntryArray = [context executeFetchRequest:dashboardEntryRequest error:nil];
    
    // Return messages at a specific index
    return [dashboardEntryArray objectAtIndex:row];

}

+ (Messages*)fetchFirstMessageFromConversation:(Conversation *)conversation inContext:(NSManagedObjectContext *)context
{
    
    // Create fetch request
    NSFetchRequest *messagesRequest = [[NSFetchRequest alloc] init];
    [messagesRequest setReturnsObjectsAsFaults:NO];
    
    // Fetch messages data
    NSEntityDescription *messagesDescription = [NSEntityDescription entityForName:kCoreDataMessages inManagedObjectContext:context];
    [messagesRequest setEntity:messagesDescription];
    
    // Only include messages that belond to this specific conversation
    NSPredicate *messagesPredicate = [NSPredicate predicateWithFormat:@"ANY conversationID == %@", conversation.conversationID];
    [messagesRequest setPredicate:messagesPredicate];
    
    // Sort by timestamp
    NSSortDescriptor *messagesTimestampSorter = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [messagesRequest setSortDescriptors:[NSArray arrayWithObject:messagesTimestampSorter]];
 
    // Execute request that returns array of dashboardEntrys
    NSArray *messagesArray = [context executeFetchRequest:messagesRequest error:nil];
    
    // Return messages at a specific index
    return [messagesArray objectAtIndex:0];
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
        
        NSDate *timestamp = [NSDate dataFromBSONstring:dashboardID];
        [dashboardEntry setValue:timestamp forKey:@"timestamp"];
        
        // Store dashboardEntry.frame attributes
        Frame *frame = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataFrame inManagedObjectContext:context];
        dashboardEntry.frame = frame;
        NSArray *frameArray = [[resultsArray objectAtIndex:i] valueForKey:@"frame"];
        [self storeFrame:frame fromFrameArray:frameArray inContext:context];
        
    }
    
    // Commity unsaved data in context
    [self saveContext:context];

    
}

+ (void)storeFrame:(Frame *)frame fromFrameArray:(NSArray *)frameArray inContext:(NSManagedObjectContext *)context
{
    
    // Store dashboardEntry.frame attributes
    NSString *frameID = [NSString testForNullForCoreDataAttribute:[frameArray valueForKey:@"id"]];
    [frame setValue:frameID forKey:@"frameID"];
        
    NSString *conversationID = [NSString testForNullForCoreDataAttribute:[frameArray valueForKey:@"conversation_id"]];
    [frame setValue:conversationID forKey:@"conversationID"];
    
    NSDate *timestamp = [NSDate dataFromBSONstring:frameID];
    [frame setValue:timestamp forKey:@"timestamp"];
    
    NSString *userID = [NSString testForNullForCoreDataAttribute:[frameArray valueForKey:@"creator_id"]];
    [frame setValue:userID forKey:@"userID"];
    
    NSString *videoID = [NSString testForNullForCoreDataAttribute:[frameArray valueForKey:@"video_id"]];
    [frame setValue:videoID forKey:@"videoID"];
    
    // Store dashboard.frame.conversation attributes
    Conversation *conversation = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataConversation inManagedObjectContext:context];
    frame.conversation = conversation;
    [self storeConversation:conversation fromframeArray:frameArray inContext:context];
    
    // Store dashboard.frame.roll attributes
    Roll *roll = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataRoll inManagedObjectContext:context];
    frame.roll = roll;
    [self storeRoll:roll fromFrameArray:frameArray inContext:context];
    
    // Store dashboard.frame.user attributes
    User *user = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataUser inManagedObjectContext:context];
    frame.user = user;
    [self storeUser:user fromFrameArray:frameArray inContext:context];
    
    // Store dashboard.frame.video attributes
    Video *video = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataVideo inManagedObjectContext:context];
    frame.video = video;
    [self storeVideo:video fromFrameArray:frameArray inContext:context];

}

+ (void)storeConversation:(Conversation *)conversation fromframeArray:(NSArray *)frameArray inContext:(NSManagedObjectContext *)context
{

    NSArray *conversationArray = [frameArray valueForKey:@"conversation"];

    NSString *conversationID = [NSString testForNullForCoreDataAttribute:[conversationArray valueForKey:@"id"]];
    [conversation setValue:conversationID forKey:@"conversationID"];
    
    // Store dashboard.frame.conversation.messages attributes
    [self storeMessagesFromConversation:conversation withConversationsArray:conversationArray inContext:context];
    
}

+ (void)storeRoll:(Roll *)roll fromFrameArray:(NSArray *)frameArray inContext:(NSManagedObjectContext *)context
{
    NSArray *rollArray = [frameArray valueForKey:@"roll"];
    
    NSString *rollID = [NSString testForNullForCoreDataAttribute:[rollArray valueForKey:@"id"]];
    [roll setValue:rollID forKey:@"rollID"];
    
    NSString *title = [NSString testForNullForCoreDataAttribute:[rollArray valueForKey:@"title"]];
    [roll setValue:title forKey:@"title"];
}

+ (void)storeMessagesFromConversation:(Conversation *)conversation 
               withConversationsArray:(NSArray *)conversationsArray 
                            inContext:(NSManagedObjectContext *)context
{

    NSArray *messagesArray = [conversationsArray valueForKey:@"messages"];

    for (int i = 0; i < [messagesArray count]; i++ ) {
       
        Messages *messages = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataMessages inManagedObjectContext:context];
        [[conversation mutableSetValueForKey:@"messages"] addObject:messages];
        
        NSString *messageID = [NSString testForNullForCoreDataAttribute:[[messagesArray objectAtIndex:i] valueForKey:@"id"]];
        [messages setValue:messageID forKey:@"messageID"];

        [messages setValue:conversation.conversationID forKey:@"conversationID"];
        
        NSString *createdAt = [NSString testForNullForCoreDataAttribute:[[messagesArray objectAtIndex:i]  valueForKey:@"created_at"]];
        [messages setValue:createdAt forKey:@"createdAt"];

        NSString *nickname = [NSString testForNullForCoreDataAttribute:[[messagesArray objectAtIndex:i]  valueForKey:@"nickname"]];
        [messages setValue:nickname forKey:@"nickname"];  

        NSString *originNetwork = [NSString testForNullForCoreDataAttribute:[[messagesArray objectAtIndex:i] valueForKey:@"origin_network"]];
        [messages setValue:originNetwork forKey:@"originNetwork"];  

        NSDate *timestamp = [NSDate dataFromBSONstring:messageID];
        [messages setValue:timestamp forKey:@"timestamp"];  
        
        NSString *text = [NSString testForNullForCoreDataAttribute:[[messagesArray objectAtIndex:i]  valueForKey:@"text"]];
        [messages setValue:text forKey:@"text"];  

        NSString *userImageURL = [NSString testForNullForCoreDataAttribute:[[messagesArray objectAtIndex:i]  valueForKey:@"user_image_url"]];
        [messages setValue:userImageURL forKey:@"userImageURL"];  
    }
    
}

+ (void)storeUser:(User *)user fromFrameArray:(NSArray *)frameArray inContext:(NSManagedObjectContext *)context
{
    
    NSArray *userArray = [frameArray valueForKey:@"creator"];
    
    NSString *userID = [NSString testForNullForCoreDataAttribute:[userArray valueForKey:@"id"]];
    [user setValue:userID forKey:@"userID"];
    
    NSString *nickname = [NSString testForNullForCoreDataAttribute:[userArray valueForKey:@"nickname"]];
    [user setValue:nickname forKey:@"nickname"];
    
    NSString *userImage = [NSString testForNullForCoreDataAttribute:[userArray valueForKey:@"user_image"]];
    [user setValue:userImage forKey:@"userImage"];

}

+ (void)storeVideo:(Video *)video fromFrameArray:(NSArray *)frameArray inContext:(NSManagedObjectContext *)context
{
    NSArray *videoArray = [frameArray valueForKey:@"video"];
    
    NSString *videoID = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"video_id"]];
    [video setValue:videoID forKey:@"videoID"];
    
    NSString *caption = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"description"]];
    [video setValue:caption forKey:@"caption"];
    
    NSString *providerName = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"provider_name"] ];
    [video setValue:providerName forKey:@"providerName"];
    
    NSString *sourceURL = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"source_url"]];
    [video setValue:sourceURL forKey:@"sourceURL"];
    
    NSString *thumbnailURL = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"thumbnail_url"]];
    [video setValue:thumbnailURL forKey:@"thumbnailURL"];
    
    NSString *title = [NSString testForNullForCoreDataAttribute:[videoArray valueForKey:@"title"]];
    [video setValue:title forKey:@"title"];
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