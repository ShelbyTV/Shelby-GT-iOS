//
//  CoreDataUtility.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CoreDataUtility.h"
#import "NSString+NullTest.h"
#import "NSDate+DateFromBSONString.h"
#import "NSString+TypedefConversion.h"
#import "SocialFacade.h"

@interface CoreDataUtility ()
{
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;     
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/// Check if entity exists in Core Data
+ (id)checkIfEntity:(NSString*)entityName 
        withIDValue:(NSString*)entityIDValue 
           forIDKey:(NSString*)entityIDKey 
    existsInContext:(NSManagedObjectContext*)context;

/// Store dashboardEntry data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forDashboardEntryInContext:(NSManagedObjectContext*)context;

/// Store dashboardEntry data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forFrameUpvotesInContext:(NSManagedObjectContext*)context;

/// Store dashbaordEntry.frame data in Core Data
+ (void)storeFrame:(Frame*)frame fromFrameArray:(NSArray*)frameArray;

/// Store dashboard.frame.conversations data in Core Data
+ (void)storeConversation:(Conversation*)conversation fromFrameArray:(NSArray*)frameArray;

/// Store dashboard.frame.conversations.messages data in Core Data
+ (void)storeMessagesFromConversation:(Conversation*)conversation withConversationsArray:(NSArray*)conversationsArray;

/// Store roll data in Core Data
+ (void)storeRoll:(Roll*)roll fromFrameArray:(NSArray*)frameArray;

/// Store dashboard.frame.user data in Core Data
+ (void)storeCreator:(Creator*)user fromFrameArray:(NSArray*)frameArray;

/// Store dashboard.frame.video data in Core Data
+ (void)storeUpvoteUsersFromFrame:(Frame*)frame withFrameArray:(NSArray*)frameArray;

/// Store dashboard.frame.video data in Core Data
+ (void)storeVideo:(Video*)video fromFrameArray:(NSArray*)frameArray;

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
    if ( requestType == APIRequestType_GetStream ) {
        
        [self storeParsedData:parsedDictionary forDashboardEntryInContext:context];
            
    } else if ( requestType == APIRequestType_GetFrame ) {
        
        [self storeParsedData:parsedDictionary forFrameUpvotesInContext:context];
        
        
    } else {
        
        // Other types (temporary for now)
        
    }
        
    // Post completion notification
    NSString *notificationName = [NSString apiRequestTypeToString:requestType];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:parsedDictionary];
}

+ (NSArray*)fetchAllDashboardEntries
{
    
    // Create fetch request
    NSFetchRequest *dashboardEntryRequest = [[NSFetchRequest alloc] init];
    [dashboardEntryRequest setReturnsObjectsAsFaults:NO];
    
    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext]; 
    NSEntityDescription *dashboardEntryDescription = [NSEntityDescription entityForName:CoreDataEntityDashboardEntry inManagedObjectContext:context];
    [dashboardEntryRequest setEntity:dashboardEntryDescription];
    
    // Sort by timestamp
    NSSortDescriptor *dashboardTimestampSorter = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [dashboardEntryRequest setSortDescriptors:[NSArray arrayWithObject:dashboardTimestampSorter]];
    
    // Execute request that returns array of dashboardEntrys
    return [context executeFetchRequest:dashboardEntryRequest error:nil];
    
}

+ (DashboardEntry*)fetchDashboardEntryDataForRow:(NSUInteger)row
{
 
    // Create fetch request
    NSFetchRequest *dashboardEntryRequest = [[NSFetchRequest alloc] init];
    [dashboardEntryRequest setReturnsObjectsAsFaults:NO];

    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext]; 
    NSEntityDescription *dashboardEntryDescription = [NSEntityDescription entityForName:CoreDataEntityDashboardEntry inManagedObjectContext:context];
    [dashboardEntryRequest setEntity:dashboardEntryDescription];
    
    // Sort by timestamp
    NSSortDescriptor *dashboardTimestampSorter = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [dashboardEntryRequest setSortDescriptors:[NSArray arrayWithObject:dashboardTimestampSorter]];
    
    // Execute request that returns array of dashboardEntrys
    NSArray *dashboardEntryArray = [context executeFetchRequest:dashboardEntryRequest error:nil];
    
    // Return messages at a specific index
    return [dashboardEntryArray objectAtIndex:row];

}

+ (Messages*)fetchFirstMessageFromConversation:(Conversation *)conversation
{
    
    // Create fetch request
    NSFetchRequest *messagesRequest = [[NSFetchRequest alloc] init];
    [messagesRequest setReturnsObjectsAsFaults:NO];
    
    // Fetch messages data
    NSManagedObjectContext *context = conversation.managedObjectContext;
    NSEntityDescription *messagesDescription = [NSEntityDescription entityForName:CoreDataEntityMessages inManagedObjectContext:context];
    [messagesRequest setEntity:messagesDescription];
    
    // Only include messages that belond to this specific conversation
    NSPredicate *messagesPredicate = [NSPredicate predicateWithFormat:@"conversationID == %@", conversation.conversationID];
    [messagesRequest setPredicate:messagesPredicate];
    
    // Sort by timestamp
    NSSortDescriptor *messagesTimestampSorter = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [messagesRequest setSortDescriptors:[NSArray arrayWithObject:messagesTimestampSorter]];
 
    // Execute request that returns array of dashboardEntrys
    NSArray *messagesArray = [context executeFetchRequest:messagesRequest error:nil];
    
    // Return messages at a specific index
    return [messagesArray objectAtIndex:0];
}

+ (BOOL)checkIfUserUpvotedInFrame:(Frame *)frame
{
    
    BOOL exists = NO;
    
    if ( frame.upvotersCount ) {
    
        // Create fetch request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setReturnsObjectsAsFaults:NO];
        
        // Fetch messages data
        NSEntityDescription *description = [NSEntityDescription entityForName:CoreDataEntityFrame inManagedObjectContext:frame.managedObjectContext];
        [request setEntity:description];
        
        // Only include objects that exist (i.e. entityIDKey and entityIDValue's must exist)
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", CoreDataFrameID, frame.frameID];
        [request setPredicate:predicate];    
        
        // Execute request that returns array of dashboardEntrys
        NSArray *frameArray = [frame.managedObjectContext executeFetchRequest:request error:nil];
        
        for (Frame *fetchedframe in frameArray) {
            
            for (UpvoteUsers *upvoteUsers in [fetchedframe upvoteUsers]) {
                
                if ( [upvoteUsers.upvoterID isEqualToString:[SocialFacade sharedInstance].shelbyCreatorID] ) {
                    
                    exists = YES;
                    
                } else {
                    
                    exists = NO;
                }

                
            }
        }
        
    
    } else {
        
        exists = NO;
    }
        
    return exists;

}

+ (void)saveContext:(NSManagedObjectContext *)context
{

    NSError *error = nil;    
    if ( context ) {
        
        if(![context save:&error]) {

            if ( DEBUGMODE ) NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            if(detailedErrors != nil && [detailedErrors count] > 0) {
                for(NSError* detailedError in detailedErrors) {
                    if ( DEBUGMODE ) NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            }
            else {
                if ( DEBUGMODE ) NSLog(@"%@", [error userInfo]);
            }
            
        } else {
            if ( DEBUGMODE ) NSLog(@"Core Data Updated!");
        }
        
    }
    
    // If this is the first time data has been loaded, post notification to dismiss LoginViewController
    if ( [SocialFacade sharedInstance].firstTimeLogin ) [[NSNotificationCenter defaultCenter] postNotificationName:TextConstants_DidFinishLoadingDataOnLogin object:nil];
}


+ (void)dumpAllData
{
    
    NSPersistentStoreCoordinator *coordinator =  [[self sharedInstance] persistentStoreCoordinator];
    NSPersistentStore *store = [[coordinator persistentStores] objectAtIndex:0];
    [[NSFileManager defaultManager] removeItemAtURL:store.URL error:nil];
    [coordinator removePersistentStore:store error:nil];
    [[self sharedInstance] setPersistentStoreCoordinator:nil];
    [[self sharedInstance] setManagedObjectContext:nil];

}

+ (id)checkIfEntity:(NSString *)entityName
        withIDValue:(NSString *)entityIDValue
           forIDKey:(NSString *)entityIDKey 
    existsInContext:(NSManagedObjectContext *)context
{

    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    
    // Fetch messages data
    NSEntityDescription *description = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:description];
    
    // Only include objects that exist (i.e. entityIDKey and entityIDValue's must exist)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", entityIDKey, entityIDValue];
    [request setPredicate:predicate];    
    
    // Execute request that returns array of dashboardEntrys
    NSArray *array = [context executeFetchRequest:request error:nil];

    if ( [array count] ) {
        return [array objectAtIndex:0];
    }

    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
}

#pragma mark - Private Methods
+ (void)storeParsedData:(NSDictionary *)parsedDictionary forDashboardEntryInContext:(NSManagedObjectContext *)context
{
 
    NSArray *resultsArray = [parsedDictionary objectForKey:APIRequest_Result];
    
    for (NSUInteger i = 0; i < [resultsArray count]; i++ ) {
        
        // Conditions for saving entires into database
        NSArray *messagesExistArray = [[[[resultsArray objectAtIndex:i] valueForKey:@"frame"] valueForKey:@"conversation"] valueForKey:@"messages"];
        NSString *sourceURLExists = [[[[resultsArray objectAtIndex:i] valueForKey:@"frame"] valueForKey:@"video"] valueForKey:@"source_url"];
        
        if ( [messagesExistArray count] && sourceURLExists ) {
            
            // Store dashboardEntry attirubutes
            DashboardEntry *dashboardEntry = [self checkIfEntity:CoreDataEntityDashboardEntry 
                                                     withIDValue:[[resultsArray objectAtIndex:i] valueForKey:@"id"]
                                                        forIDKey:CoreDataDashboardEntryID 
                                                 existsInContext:context];
            
            NSString *dashboardID = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"id"]];
            [dashboardEntry setValue:dashboardID forKey:CoreDataDashboardEntryID];
            
            NSDate *timestamp = [NSDate dataFromBSONstring:dashboardID];
            [dashboardEntry setValue:timestamp forKey:CoreDataDashboardEntryTimestamp];
            
            // Store dashboardEntry.frame attributes
            NSArray *frameArray = [[resultsArray objectAtIndex:i] valueForKey:@"frame"];        
            Frame *frame = [self checkIfEntity:CoreDataEntityFrame
                                   withIDValue:[frameArray valueForKey:@"id"]
                                      forIDKey:CoreDataFrameID  
                               existsInContext:context];
            dashboardEntry.frame = frame;
            
            // Check to make sure messages exist
            [self storeFrame:frame fromFrameArray:frameArray];
            
        }
        
    }
        // Commity unsaved data in context
        [self saveContext:context];
    
}

+ (void)storeParsedData:(NSDictionary *)parsedDictionary forFrameUpvotesInContext:(NSManagedObjectContext *)context
{
    
    NSArray *frameArray = [parsedDictionary objectForKey:APIRequest_Result];
    
    Frame *frame = [self checkIfEntity:CoreDataEntityFrame
                           withIDValue:[frameArray valueForKey:@"id"]
                              forIDKey:CoreDataFrameID  
                       existsInContext:context];

    // Check to make sure messages exist
    NSArray *upvotersArray = [NSArray arrayWithArray:[frameArray valueForKey:@"upvoters"]];
    NSUInteger upvotersCount = [upvotersArray count];
    [frame setValue:[NSNumber numberWithInt:upvotersCount] forKey:CoreDataFrameUpvotersCount];
        
    // Store dashboard.frame.upvoteUsers attributes if upvoteUsers exist
    if ( upvotersCount ) {
        
        [self storeUpvoteUsersFromFrame:frame withFrameArray:frameArray];
        
    }
    
    // Commity unsaved data in context
    [self saveContext:context];
    
}

+ (void)storeFrame:(Frame *)frame fromFrameArray:(NSArray *)frameArray
{
    
    // Store dashboardEntry.frame attributes
    NSString *frameID = [NSString testForNull:[frameArray valueForKey:@"id"]];
    [frame setValue:frameID forKey:CoreDataFrameID ];
        
    NSString *conversationID = [NSString testForNull:[frameArray valueForKey:@"conversation_id"]];
    [frame setValue:conversationID forKey:CoreDataFrameConversationID];
    
    NSString *createdAt = [NSString testForNull:[frameArray valueForKey:@"creator_at"]];
    [frame setValue:createdAt forKey:CoreDataFrameCreatedAt ];
    
    NSString *creatorID = [NSString testForNull:[frameArray valueForKey:@"creator_id"]];
    [frame setValue:creatorID forKey:CoreDataFrameCreatorID ];
    
    NSString *rollID = [NSString testForNull:[frameArray valueForKey:@"roll_id"]];
    [frame setValue:rollID forKey:CoreDataFrameRollID];
    
    NSDate *timestamp = [NSDate dataFromBSONstring:frameID];
    [frame setValue:timestamp forKey:CoreDataFrameTimestamp];

    NSArray *upvotersArray = [NSArray arrayWithArray:[frameArray valueForKey:@"upvoters"]];
    NSUInteger upvotersCount = [upvotersArray count];
    [frame setValue:[NSNumber numberWithInt:upvotersCount] forKey:CoreDataFrameUpvotersCount];
    
    NSString *videoID = [NSString testForNull:[frameArray valueForKey:@"video_id"]];
    [frame setValue:videoID forKey:CoreDataFrameVideoID ];
    
    // Store dashboard.frame.conversation attributes
    NSManagedObjectContext *context = frame.managedObjectContext;
    Conversation *conversation = [self checkIfEntity:CoreDataEntityConversation 
                    withIDValue:conversationID
                       forIDKey:CoreDataFrameConversationID
                existsInContext:context];
    frame.conversation = conversation;
    [conversation addFrameObject:frame];
    [self storeConversation:conversation fromFrameArray:frameArray];
    
    // Store dashboard.frame.roll attributes if roll exists
    if ( rollID ) {
        Roll *roll = [self checkIfEntity:CoreDataEntityRoll 
                             withIDValue:rollID
                                forIDKey:CoreDataFrameRollID 
                         existsInContext:context];
        frame.roll = roll;
        [roll addFrameObject:frame];
        [self storeRoll:roll fromFrameArray:frameArray];
    }

    // Store dashboard.frame.upvoteUsers attributes if upvoteUsers exist
    if ( upvotersCount ) {

        [self storeUpvoteUsersFromFrame:frame withFrameArray:frameArray];
   
    }
    
    // Store dashboard.frame.user attributes
    Creator *creator = [self checkIfEntity:CoreDataEntityCreator 
                               withIDValue:creatorID
                                  forIDKey:CoreDataFrameCreatorID
                           existsInContext:context];
    frame.creator = creator;
    [creator addFrameObject:frame];
    [self storeCreator:creator fromFrameArray:frameArray];
    
    // Store dashboard.frame.video attributes
    Video *video = [self checkIfEntity:CoreDataEntityVideo 
                           withIDValue:videoID
                              forIDKey:CoreDataFrameVideoID
                       existsInContext:context];
    
    frame.video = video;
    [video addFrameObject:frame];
    [self storeVideo:video fromFrameArray:frameArray];

}

+ (void)storeConversation:(Conversation *)conversation fromFrameArray:(NSArray *)frameArray
{

    NSArray *conversationArray = [frameArray valueForKey:@"conversation"];

    NSString *conversationID = [NSString testForNull:[conversationArray valueForKey:@"id"]];
    [conversation setValue:conversationID forKey:CoreDataConversationID];
    
    // Store dashboard.frame.conversation.messages attributes
    [self storeMessagesFromConversation:conversation withConversationsArray:conversationArray];
    
}

+ (void)storeMessagesFromConversation:(Conversation *)conversation withConversationsArray:(NSArray *)conversationsArray 
{

    NSArray *messagesArray = [conversationsArray valueForKey:@"messages"];

    [conversation setValue:[NSNumber numberWithInt:[messagesArray count]] forKey:CoreDataConversationMessageCount];
    
    for (int i = 0; i < [messagesArray count]; i++ ) {
       
        NSManagedObjectContext *context = conversation.managedObjectContext;
        Messages *messages = [self checkIfEntity:CoreDataEntityMessages 
                           withIDValue:[[messagesArray objectAtIndex:i] valueForKey:@"id"]
                              forIDKey:CoreDataMessagesID
                       existsInContext:context];
        
        [conversation addMessagesObject:messages];
        
        // Hold reference to parent conversationID
        [messages setValue:conversation.conversationID forKey:CoreDataConversationID];
        
        NSString *messageID = [NSString testForNull:[[messagesArray objectAtIndex:i] valueForKey:@"id"]];
        [messages setValue:messageID forKey:CoreDataMessagesID];
        
        NSString *createdAt = [NSString testForNull:[[messagesArray objectAtIndex:i]  valueForKey:@"created_at"]];
        [messages setValue:createdAt forKey:CoreDataMessagesCreatedAt];

        NSString *nickname = [NSString testForNull:[[messagesArray objectAtIndex:i]  valueForKey:@"nickname"]];
        [messages setValue:nickname forKey:CoreDataMessagesNickname];  

        NSString *originNetwork = [NSString testForNull:[[messagesArray objectAtIndex:i] valueForKey:@"origin_network"]];
        [messages setValue:originNetwork forKey:CoreDataMessagesOriginNetwork];  

        NSDate *timestamp = [NSDate dataFromBSONstring:messageID];
        [messages setValue:timestamp forKey:CoreDataMessagesTimestamp];  
        
        NSString *text = [NSString testForNull:[[messagesArray objectAtIndex:i]  valueForKey:@"text"]];
        [messages setValue:text forKey:CoreDataMessagesText];  

        NSString *userImageURL = [NSString testForNull:[[messagesArray objectAtIndex:i]  valueForKey:@"user_image_url"]];
        [messages setValue:userImageURL forKey:CoreDataMessagesUserImageURL];  
    
    }

}

+ (void)storeRoll:(Roll *)roll fromFrameArray:(NSArray *)frameArray
{
    NSArray *rollArray = [frameArray valueForKey:@"roll"];
    
    NSString *rollID = [NSString testForNull:[rollArray valueForKey:@"id"]];
    [roll setValue:rollID forKey:CoreDataRollID];
    
    NSString *title = [NSString testForNull:[rollArray valueForKey:@"title"]];
    [roll setValue:title forKey:CoreDataRollTitle];
}

+ (void)storeUpvoteUsersFromFrame:(Frame *)frame withFrameArray:(NSArray *)frameArray
{
   
    NSArray *upvoteUsersArray = [frameArray valueForKey:@"upvote_users"];
    
    for (int i = 0; i < [upvoteUsersArray count]; i++ ) {
        
        NSManagedObjectContext *context = frame.managedObjectContext;
        UpvoteUsers *upvoteUsers  = [self checkIfEntity:CoreDataEntityUpvoteUsers 
                                            withIDValue:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"id"]
                                               forIDKey:CoreDataUpvoteUserID
                                        existsInContext:context];
        [frame addUpvoteUsersObject:upvoteUsers];
        
        NSString *upvoterID = [NSString testForNull:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"id"]];
        [upvoteUsers setValue:upvoterID forKey:CoreDataUpvoteUserID];
        
        NSString *nickname = [NSString testForNull:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"nickname"]];
        [upvoteUsers setValue:nickname forKey:CoreDataUpvoteUsersNickname];
        
        NSString *rollID = [NSString testForNull:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"rollID"]];
        [upvoteUsers setValue:rollID forKey:CoreDataUpvoteUsersRollID];
        
        NSString *userImage = [NSString testForNull:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"userInage"]];
        [upvoteUsers setValue:userImage forKey:CoreDataUpvoteUsersImage];
        
    
    }
}

+ (void)storeCreator:(Creator *)user fromFrameArray:(NSArray *)frameArray
{
    
    NSArray *userArray = [frameArray valueForKey:@"creator"];
    
    NSString *userID = [NSString testForNull:[userArray valueForKey:@"id"]];
    [user setValue:userID forKey:CoreDataUserID];
    
    NSString *nickname = [NSString testForNull:[userArray valueForKey:@"nickname"]];
    [user setValue:nickname forKey:CoreDataUserNickname];
    
    NSString *userImage = [NSString testForNull:[userArray valueForKey:@"user_image"]];
    [user setValue:userImage forKey:CoreDataUserImage];

}

+ (void)storeVideo:(Video *)video fromFrameArray:(NSArray *)frameArray
{
    NSArray *videoArray = [frameArray valueForKey:@"video"];
    
    NSString *videoID = [NSString testForNull:[videoArray valueForKey:@"id"]];
    [video setValue:videoID forKey:CoreDataVideoID];
    
    NSString *caption = [NSString testForNull:[videoArray valueForKey:@"description"]];
    [video setValue:caption forKey:CoreDataVideoCaption];
    
    NSString *providerName = [NSString testForNull:[videoArray valueForKey:@"provider_name"] ];
    [video setValue:providerName forKey:CoreDataVideoProviderName];
    
    NSString *sourceURL = [NSString testForNull:[videoArray valueForKey:@"source_url"]];
    [video setValue:sourceURL forKey:CoreDataVideoSourceURL];
    
    NSString *thumbnailURL = [NSString testForNull:[videoArray valueForKey:@"thumbnail_url"]];
    [video setValue:thumbnailURL forKey:CoreDataVideoThumbnailURL];
    
    NSString *title = [NSString testForNull:[videoArray valueForKey:@"title"]];
    [video setValue:title forKey:CoreDataVideoTitle];
    
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