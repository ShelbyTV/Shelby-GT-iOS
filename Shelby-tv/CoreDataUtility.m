//
//  CoreDataUtility.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CoreDataUtility.h"
#import "NSString+NullTest.h"
#import "NSDate+DateFromBSONString.h"
#import "NSString+TypedefConversion.h"
#import "ShelbyAPIClient.h"
#import "SocialFacade.h"
#import "AppDelegate.h"

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

/// Store shelbyUser data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forShelbyUserInContext:(NSManagedObjectContext*)context;

/// Store rollsFollowing data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forRollsFollowingInContext:(NSManagedObjectContext*)context;

/// Store exploreRolls data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forExploreRollsInContext:(NSManagedObjectContext*)context;

/// Store new/created roll data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forCreatedRollInContext:(NSManagedObjectContext*)context;

/// Store dashboardEntry data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forDashboardEntryInContext:(NSManagedObjectContext*)context;

/// Store frame data in Core Data
+ (void)storeFrame:(Frame*)frame fromFrameArray:(NSArray*)frameArray;

/// Store multiples frame data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forFramesInContext:(NSManagedObjectContext*)context;

/// Store conversation/message data in Core Data
+ (void)storeParsedData:(NSDictionary*)parsedDictionary forConversationInContext:(NSManagedObjectContext*)context;

/// Store frame.conversations data in Core Data
+ (void)storeConversation:(Conversation*)conversation fromFrameArray:(NSArray*)frameArray;

/// Store frame.conversations.messages data in Core Data
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
+ (void)storeParsedData:(NSDictionary *)parsedDictionary inCoreData:(NSManagedObjectContext *)context forType:(APIRequestType)requestType
{
    
    [[self sharedInstance] setRequestType:requestType];
    
    switch ( requestType ) {
            
        case APIRequestType_PostToken:
            [self storeParsedData:parsedDictionary forShelbyUserInContext:context];
            break;
            
        case APIRequestType_GetStream:
            [self storeParsedData:parsedDictionary forDashboardEntryInContext:context];
            break;
            
        case APIRequestType_GetRollsFollowing:
            [self storeParsedData:parsedDictionary forRollsFollowingInContext:context];
            break;
            
        case APIRequestType_GetExploreRolls:
            [self storeParsedData:parsedDictionary forExploreRollsInContext:context];
            break;
            
        case APIRequestType_GetRollFrames:
            [self storeParsedData:parsedDictionary forFramesInContext:context];
            break;
       
        case APIRequestType_PostCreateRoll:
            [self storeParsedData:parsedDictionary forCreatedRollInContext:context];
            break;
            
        case APIRequestType_PostMessage:
            [self storeParsedData:parsedDictionary forConversationInContext:context];
            break;
            
        default:
            break;
    }
    

}

+ (ShelbyUser*)fetchShelbyAuthData
{
    
    // Create fetch request
    NSFetchRequest *shelbyTokenRequest = [[NSFetchRequest alloc] init];
    [shelbyTokenRequest setReturnsObjectsAsFaults:NO];
    
    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext];
    NSEntityDescription *shelbyDescription = [NSEntityDescription entityForName:CoreDataEntityShelbyUser inManagedObjectContext:context];
    [shelbyTokenRequest setEntity:shelbyDescription];
    
    // Execute request that returns array of dashboardEntrys
    return [[context executeFetchRequest:shelbyTokenRequest error:nil] objectAtIndex:0];
    
}

+ (NSArray*)fetchAllDashboardEntries
{
    
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    
    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext]; 
    NSEntityDescription *description = [NSEntityDescription entityForName:CoreDataEntityDashboardEntry inManagedObjectContext:context];
    [request setEntity:description];
    
    // Sort by timestamp
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // Execute request that returns array of dashboardEntrys
    return [context executeFetchRequest:request error:nil];
    
}

+ (NSArray*)fetchExploreRolls
{
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    
    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext];
    NSEntityDescription *description = [NSEntityDescription entityForName:CoreDataEntityRoll inManagedObjectContext:context];
    [request setEntity:description];
    
    // Only include messages that belond to this specific conversation
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isExplore == %d", YES];
    [request setPredicate:predicate];
    
    // Execute request that returns array of dashboardEntrys
    return [context executeFetchRequest:request error:nil];
}

+ (NSArray*)fetchMyRolls
{
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    
    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext];
    NSEntityDescription *description = [NSEntityDescription entityForName:CoreDataEntityRoll inManagedObjectContext:context];
    [request setEntity:description];
    
    // Only include messages that belond to this specific conversation
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMy == %d", YES];
    [request setPredicate:predicate];
    
    // Execute request that returns array of dashboardEntrys
    return [context executeFetchRequest:request error:nil];
}

+ (NSArray*)fetchFriendsRolls
{
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    
    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext];
    NSEntityDescription *description = [NSEntityDescription entityForName:CoreDataEntityRoll inManagedObjectContext:context];
    [request setEntity:description];
    
    // Only include messages that belond to this specific conversation
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFriends == %d", YES];
    [request setPredicate:predicate];
    
    // Execute request that returns array of dashboardEntrys
    return [context executeFetchRequest:request error:nil];
}

+ (NSArray*)fetchFramesForRoll:(NSString*)rollID
{
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    
    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext];
    NSEntityDescription *description = [NSEntityDescription entityForName:CoreDataEntityFrame inManagedObjectContext:context];
    [request setEntity:description];
    
    // Only include the frame that belongs to this specific roll
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rollID == %@", rollID];
    [request setPredicate:predicate];
    
    // Execute request that returns array of dashboardEntrys
    return [context executeFetchRequest:request error:nil];
}

+ (DashboardEntry*)fetchDashboardEntryDataForDashboardID:(NSString*)dashboardID
{
 
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];

    // Fetch dashboardEntry data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext]; 
    NSEntityDescription *description = [NSEntityDescription entityForName:CoreDataEntityDashboardEntry inManagedObjectContext:context];
    [request setEntity:description];
    
    // Only include the frame that belongs to this specific roll
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dashboardID == %@", dashboardID];
    [request setPredicate:predicate];
    
    // Execute request that returns array of dashboardEntrys
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    // Return messages at a specific index
    return [array objectAtIndex:0];

}

+ (Roll*)fetchRollWithTitle:(NSString *)title
{
    
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    
    // Fetch roll data
    NSManagedObjectContext *context = [[self sharedInstance] managedObjectContext];
    NSEntityDescription *dashboardEntryDescription = [NSEntityDescription entityForName:CoreDataEntityRoll inManagedObjectContext:context];
    [request setEntity:dashboardEntryDescription];
    
    // Only include the frame we're looking for
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@ AND creatorID == %@", title, [SocialFacade sharedInstance].shelbyCreatorID];
    [request setPredicate:predicate];
    
    // Execute request that returns array of dashboardEntrys
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    // Return messages at a specific index
    return [array objectAtIndex:0];
    
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
    
    return ( [messagesArray count] ) ? [messagesArray objectAtIndex:0] : nil;

}

+ (NSArray*)fetchAllMessagesFromConversation:(Conversation *)conversation
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
    NSSortDescriptor *messagesTimestampSorter = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [messagesRequest setSortDescriptors:[NSArray arrayWithObject:messagesTimestampSorter]];
    
    return [context executeFetchRequest:messagesRequest error:nil];
    
}

+ (BOOL)checkIfUserUpvotedInFrame:(Frame *)frame
{
    
    BOOL upvoted = NO;
    
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
                    
                    upvoted = YES;
                    
                } else {
                    
                    upvoted = NO;
                }

                
            }
        }
        
    
    } else {
        
        upvoted = NO;
    }
        
    return upvoted;

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
            
            // If this is the first time data has been loaded, post notification to dismiss LoginViewController
            if ( [SocialFacade sharedInstance].firstTimeLogin == YES ) {

                switch ( [CoreDataUtility sharedInstance].requestType ) {
                        
                    case APIRequestType_GetStream:{
                        
                        
                        // Stream is saved, so get RollsFollowing
                        [[self sharedInstance] setRequestType:APIRequestType_None];
                        NSString *rollsFollowingRequestString = [NSString stringWithFormat:APIRequest_GetRollsFollowing, [SocialFacade sharedInstance].shelbyCreatorID, [SocialFacade sharedInstance].shelbyToken];
                         NSMutableURLRequest *rollsFollowing = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:rollsFollowingRequestString]];
                         ShelbyAPIClient *rollsFollowingClient = [[ShelbyAPIClient alloc] init];
                         [rollsFollowingClient performRequest:rollsFollowing ofType:APIRequestType_GetRollsFollowing];
                        
                        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                        [appDelegate addHUDWithMessage:@"Getting Private Rolls (Step 2 of 3)"];
                        
                    } break;
                        
                    case APIRequestType_GetRollsFollowing:{
                        
                        // RollsFollowing is saved, so get ExploreRolls
                        [[self sharedInstance] setRequestType:APIRequestType_None];
                         NSString *rollsFollowingRequestString = [NSString stringWithFormat:APIRequest_GetExploreRolls, [SocialFacade sharedInstance].shelbyToken];
                         NSMutableURLRequest *rollsFollowingRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:rollsFollowingRequestString]];
                         ShelbyAPIClient *rollsFollowingClient = [[ShelbyAPIClient alloc] init];
                         [rollsFollowingClient performRequest:rollsFollowingRequest ofType:APIRequestType_GetExploreRolls];
                        
                        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                        [appDelegate addHUDWithMessage:@"Getting Public Rolls (Step 3 of 3)"];
                        
                    } break;
                        
                    case APIRequestType_GetExploreRolls:{
                        
                        // Explore Rolls is saved, so release LoginViewController
                        [[self sharedInstance] setRequestType:APIRequestType_None];
                        [[SocialFacade sharedInstance] setFirstTimeLogin:NO];
                        [[NSNotificationCenter defaultCenter] postNotificationName:TextConstants_CoreData_DidFinishLoadingDataOnLogin object:nil];
                        
                    } break;
                        
                    default:
                        break;
                }
                
            }
            
        }
        
        // Post notification to observers
        NSString *notificationName = [NSString requestTypeToString:[CoreDataUtility sharedInstance].requestType];
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
    }
    
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
    
    // Execute request that returns array with one object, the requested entity
    NSArray *array = [context executeFetchRequest:request error:nil];

    if ( [array count] ) {
        return [array objectAtIndex:0];
    }

    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
}

#pragma mark - Private Methods
+ (void)storeParsedData:(NSDictionary *)parsedDictionary forShelbyUserInContext:(NSManagedObjectContext *)context
{
    
    ShelbyUser *shelbyUser = [self checkIfEntity:CoreDataEntityShelbyUser
                                             withIDValue:[parsedDictionary valueForKey:@"id"]
                                                forIDKey:CoreDataShelbyUserID
                                         existsInContext:context];
    
    NSDictionary *resultsDictionary = [parsedDictionary valueForKey:APIRequest_Result];
    
    NSString *userID= [NSString testForNull:[resultsDictionary valueForKey:@"id"]];
    [shelbyUser setValue:userID forKey:CoreDataShelbyUserID];

    NSString *authToken = [NSString testForNull:[resultsDictionary valueForKey:@"authentication_token"]];
    [shelbyUser setValue:authToken forKey:CoreDataShelbyUserAuthToken];
    
    NSString *nickname = [NSString testForNull:[resultsDictionary valueForKey:@"nickname"]];
    [shelbyUser setValue:nickname forKey:CoreDataShelbyUserNickname];
    
    NSString *heartRollID = [NSString testForNull:[resultsDictionary valueForKey:@"heart_roll_id"]];
    [shelbyUser setValue:heartRollID forKey:CoreDataShelbyUserHeartRollID];
    
    NSString *personalRollID = [NSString testForNull:[resultsDictionary valueForKey:@"personal_roll_id"]];
    [shelbyUser setValue:personalRollID forKey:CoreDataShelbyUserPersonalRollID];
    
    NSString *userImage = [NSString testForNull:[resultsDictionary valueForKey:@"user_image"]];
    [shelbyUser setValue:userImage forKey:CoreDataShelbyUserImage];
    
    NSString *watchLaterRollID = [NSString testForNull:[resultsDictionary valueForKey:@"watch_later_roll_id"]];
    [shelbyUser setValue:watchLaterRollID forKey:CoreDataShelbyUserWatchLaterRollID];
    
    NSArray *authenticationsArray = [resultsDictionary valueForKey:@"authentications"];
    
    // Set default social network authentication values to NO
    shelbyUser.authenticatedWithFacebook = [NSNumber numberWithBool:NO];
    shelbyUser.authenticatedWithTwitter= [NSNumber numberWithBool:NO];
    shelbyUser.authenticatedWithTumblr = [NSNumber numberWithBool:NO];
    
    NSUInteger count = 0;
    while ( count < [authenticationsArray count] ) {
        
        if ( [[[authenticationsArray objectAtIndex:count] valueForKey:@"provider"] isEqualToString:@"facebook"] ) {
            
            shelbyUser.authenticatedWithFacebook = [NSNumber numberWithBool:YES];
            
        } else if ( [[[authenticationsArray objectAtIndex:count] valueForKey:@"provider"] isEqualToString:@"twitter"] ) {
            
            shelbyUser.authenticatedWithTwitter= [NSNumber numberWithBool:YES];
            
        } else if ( [[[authenticationsArray objectAtIndex:count] valueForKey:@"provider"] isEqualToString:@"tumblr"] ) {
            
            shelbyUser.authenticatedWithTumblr = [NSNumber numberWithBool:YES];
            
        }
        
        count++;
    }
   
        
    [self saveContext:context];
}

+ (void)storeParsedData:(NSDictionary *)parsedDictionary forRollsFollowingInContext:(NSManagedObjectContext *)context
{
    NSArray *resultsArray = [parsedDictionary valueForKey:APIRequest_Result];
    
    for (NSUInteger i = 0; i < [resultsArray count]; i++ ) {
        
        // Conditions for saving entires into database
        BOOL sourceURLExists = [[[[[resultsArray objectAtIndex:i] valueForKey:@"frame"] valueForKey:@"video"] valueForKey:@"source_url"] isKindOfClass:[NSNull class]] ? NO : YES;
        BOOL embedURLExists = [[[[[resultsArray objectAtIndex:i] valueForKey:@"frame"] valueForKey:@"video"] valueForKey:@"embed_url"] isKindOfClass:[NSNull class]] ? NO : YES;
        id frameReturned = [[resultsArray objectAtIndex:i] valueForKey:@"frame"];
        BOOL frameNull = [frameReturned isKindOfClass:([NSNull class])] ? YES : NO;
        
        if ( YES == frameNull ) {
            
            // Do Nothing
        
        } else if ( YES == sourceURLExists || YES == embedURLExists ) { // && NO == frameNull
                    
            Roll *roll = [self checkIfEntity:CoreDataEntityRoll
                                 withIDValue:[[resultsArray objectAtIndex:i] valueForKey:@"id"]
                                    forIDKey:CoreDataRollID
                             existsInContext:context];
        
            NSString *rollID = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"id"]];
            [roll setValue:rollID forKey:CoreDataRollID];
            
            NSString *creatorID = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"creator_id"]];
            [roll setValue:creatorID forKey:CoreDataRollCreatorID];
            
            NSString *nickname = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"creator_nickname"]];
            [roll setValue:nickname forKey:CoreDataRollCreatorNickname];
            
            NSNumber *frameCount = [[resultsArray objectAtIndex:i] valueForKey:@"frame_count"];
            [roll setValue:frameCount forKey:CoreDataRollFrameCount];
            
            NSNumber *followingCount = [[resultsArray objectAtIndex:i] valueForKey:@"following_user_count"];
            [roll setValue:followingCount forKey:CoreDataRollFollowingCount];
                    
            NSString *thumbnailURL = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"first_frame_thumbnail_url"]];
            [roll setValue:thumbnailURL forKey:CoreDataRollThumbnailURL];
            
            NSString *title = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"title"]];
            [roll setValue:title forKey:CoreDataRollTitle];
            
            roll.isCollaborative = [[resultsArray objectAtIndex:i] valueForKey:@"collaborative"];
            roll.isGenius = [[resultsArray objectAtIndex:i] valueForKey:@"genius"];
            roll.isPublic = [[resultsArray objectAtIndex:i] valueForKey:@"public"];
            
            // Set Initial Values
            roll.isMy = [NSNumber numberWithBool:NO];
            roll.isFriends = [NSNumber numberWithBool:NO];
            
            // Set Separated Conditional Values
            if ( [roll.isPublic boolValue] && ![roll.isCollaborative boolValue] ) { // Public and Non-Collaborative
                
                roll.isFriends = [NSNumber numberWithBool:YES];
                
            }
            
            if ( [roll.isPublic boolValue] && [roll.isCollaborative boolValue] ) { // Public and Collaborative
                
                roll.isMy = [NSNumber numberWithBool:YES];
             
            }
            
            if ( ![roll.isPublic boolValue] ) { // Private
                
                roll.isMy = [NSNumber numberWithBool:YES];
                
            }
                
            if ( [creatorID isEqualToString:[SocialFacade sharedInstance].shelbyCreatorID] ) { //
                
                roll.isMy = [NSNumber numberWithBool:YES];
                
            }
            
            
        } else {
            
            // Do Nothing
            
        }
    
    }
        
    
    [self saveContext:context];
}

+ (void)storeParsedData:(NSDictionary *)parsedDictionary forExploreRollsInContext:(NSManagedObjectContext *)context
{
    NSArray *resultsArray = [parsedDictionary valueForKey:APIRequest_Result];
    
    for (NSUInteger i = 0; i < [resultsArray count]; i++ ) {
        
        Roll *roll = [self checkIfEntity:CoreDataEntityRoll
                             withIDValue:[[resultsArray objectAtIndex:i] valueForKey:@"id"]
                                forIDKey:CoreDataRollID
                         existsInContext:context];
        
        NSString *rollID = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"id"]];
        [roll setValue:rollID forKey:CoreDataRollID];
        
        NSString *creatorID = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"creator_id"]];
        [roll setValue:creatorID forKey:CoreDataRollCreatorID];
        
        NSString *nickname = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"creator_nickname"]];
        [roll setValue:nickname forKey:CoreDataRollCreatorNickname];
        
        NSNumber *frameCount = [[resultsArray objectAtIndex:i] valueForKey:@"frame_count"];
        [roll setValue:frameCount forKey:CoreDataRollFrameCount];
        
        NSNumber *followingCount = [[resultsArray objectAtIndex:i] valueForKey:@"following_user_count"];
        [roll setValue:followingCount forKey:CoreDataRollFollowingCount];
        
        NSString *thumbnailURL = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"first_frame_thumbnail_url"]];
        [roll setValue:thumbnailURL forKey:CoreDataRollThumbnailURL];
        
        NSString *title = [NSString testForNull:[[resultsArray objectAtIndex:i] valueForKey:@"title"]];
        [roll setValue:title forKey:CoreDataRollTitle];
        
        roll.isCollaborative = [[resultsArray objectAtIndex:i] valueForKey:@"collaborative"];
        
        roll.isGenius = [[resultsArray objectAtIndex:i] valueForKey:@"genius"];
        
        roll.isPublic = [[resultsArray objectAtIndex:i] valueForKey:@"public"];
        
        roll.isExplore = [NSNumber numberWithBool:YES];
    
    }
    
    [self saveContext:context];
    
}

+ (void)storeParsedData:(NSDictionary *)parsedDictionary forCreatedRollInContext:(NSManagedObjectContext *)context
{
    NSArray *resultsArray = [parsedDictionary valueForKey:APIRequest_Result];
    
    Roll *roll = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityRoll inManagedObjectContext:context];
    
    NSString *rollID = [NSString testForNull:[resultsArray valueForKey:@"id"]];
    [roll setValue:rollID forKey:CoreDataRollID];

    NSString *creatorID = [NSString testForNull:[resultsArray valueForKey:@"creator_id"]];
    [roll setValue:creatorID forKey:CoreDataRollCreatorID];
    
    NSString *nickname = [NSString testForNull:[resultsArray  valueForKey:@"creator_nickname"]];
    [roll setValue:nickname forKey:CoreDataRollCreatorNickname];
    
    NSNumber *frameCount = [resultsArray  valueForKey:@"frame_count"];
    [roll setValue:frameCount forKey:CoreDataRollFrameCount];
    
    NSNumber *followingCount = [resultsArray valueForKey:@"following_user_count"];
    [roll setValue:followingCount forKey:CoreDataRollFollowingCount];
    
    NSString *thumbnailURL = [NSString testForNull:[resultsArray valueForKey:@"first_frame_thumbnail_url"]];
    [roll setValue:thumbnailURL forKey:CoreDataRollThumbnailURL];
    
    NSString *title = [NSString testForNull:[resultsArray valueForKey:@"title"]];
    [roll setValue:title forKey:CoreDataRollTitle];
    
    roll.isCollaborative = [resultsArray valueForKey:@"collaborative"];
    roll.isGenius = [resultsArray valueForKey:@"genius"];
    roll.isPublic = [resultsArray valueForKey:@"public"];
    
    // Set Initial Values
    roll.isMy = [NSNumber numberWithBool:NO];
    roll.isFriends = [NSNumber numberWithBool:NO];
    
    // Set Separated Conditional Values
    if ( [roll.isPublic boolValue] && ![roll.isCollaborative boolValue] ) { // Public and Non-Collaborative
        
        roll.isFriends = [NSNumber numberWithBool:YES];
        
    }
    
    if ( [roll.isPublic boolValue] && [roll.isCollaborative boolValue] ) { // Public and Collaborative
        
        roll.isMy = [NSNumber numberWithBool:YES];
        
    }
    
    if ( ![roll.isPublic boolValue] ) { // Private
        
        roll.isMy = [NSNumber numberWithBool:YES];
        
    }
    
    if ( [creatorID isEqualToString:[SocialFacade sharedInstance].shelbyCreatorID] ) { //
        
        roll.isMy = [NSNumber numberWithBool:YES];
        
    }

    [self saveContext:context];
    
}

+ (void)storeParsedData:(NSDictionary *)parsedDictionary forFramesInContext:(NSManagedObjectContext *)context
{
    
    NSArray *resultsArray = [[parsedDictionary objectForKey:APIRequest_Result] valueForKey:@"frames"];
    
    for (NSUInteger i = 0; i < [resultsArray count]; i++ ) {
        
        NSArray *frameArray = [resultsArray objectAtIndex:i];
        
        Frame *frame = [CoreDataUtility checkIfEntity:CoreDataEntityFrame
                                          withIDValue:[frameArray valueForKey:@"id"]
                                             forIDKey:CoreDataFrameID
                                      existsInContext:context];
        
        [self storeFrame:frame fromFrameArray:frameArray];
    }
    
    [self saveContext:context];
}

+ (void)storeParsedData:(NSDictionary *)parsedDictionary forConversationInContext:(NSManagedObjectContext *)context
{
    NSArray *resultsArray = [parsedDictionary objectForKey:APIRequest_Result];
    
    Conversation *conversation = [self checkIfEntity:CoreDataEntityConversation
                                         withIDValue:[resultsArray valueForKey:@"id"]
                                            forIDKey:CoreDataFrameConversationID
                                     existsInContext:context];
    
    
    NSArray *messagesArray = [resultsArray valueForKey:@"messages"];
    
    // Update messageCount on conversation
    [conversation setMessageCount:[NSNumber numberWithInt:[messagesArray count]]];
    
    for ( NSUInteger i = 0; i < [messagesArray count]; i++ ) {
        
        NSManagedObjectContext *context = conversation.managedObjectContext;
        Messages *messages = [self checkIfEntity:CoreDataEntityMessages
                                     withIDValue:[[messagesArray objectAtIndex:i] valueForKey:@"id"]
                                        forIDKey:CoreDataMessagesID
                                 existsInContext:context];
        
        [conversation addMessagesObject:messages];

        // Hold reference to parent conversationID
        [messages setValue:conversation.conversationID forKey:CoreDataConversationID];
        
        // Set values for new message
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
        
        NSString *userImage = [NSString testForNull:[[messagesArray objectAtIndex:i]  valueForKey:@"user_image_url"]];
        [messages setValue:userImage forKey:CoreDataMessagesUserImage];
        
    }

    [CoreDataUtility saveContext:context];
    
}

+ (void)storeParsedData:(NSDictionary *)parsedDictionary forDashboardEntryInContext:(NSManagedObjectContext *)context
{
 
    NSArray *resultsArray = [parsedDictionary objectForKey:APIRequest_Result];
    
    for (NSUInteger i = 0; i < [resultsArray count]; i++ ) {
        
        // Conditions for saving entires into database 
        
        BOOL sourceURLExists = [[[[[resultsArray objectAtIndex:i] valueForKey:@"frame"] valueForKey:@"video"] valueForKey:@"source_url"] isKindOfClass:[NSNull class]] ? NO : YES;
        BOOL embedURLExists = [[[[[resultsArray objectAtIndex:i] valueForKey:@"frame"] valueForKey:@"video"] valueForKey:@"embed_url"] isKindOfClass:[NSNull class]] ? NO : YES;
        Frame *returnedFrame = [[resultsArray objectAtIndex:i] valueForKey:@"frame"];
        BOOL frameNull = [returnedFrame isKindOfClass:([NSNull class])] ? YES : NO;
        
        if ( YES == frameNull ) {
        
            // Do Nothing
            
        } else if ( YES == sourceURLExists || YES == embedURLExists ) { // && NO == frameNull
            
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
            
        } else {
            
            // Do Nothing
            
        }
        
    }
    
    [self saveContext:context];
}

+ (void)storeFrame:(Frame *)frame fromFrameArray:(NSArray *)frameArray
{
    
    // Store dashboardEntry.frame attributes
    NSString *frameID = [NSString testForNull:[frameArray valueForKey:@"id"]];
    [frame setValue:frameID forKey:CoreDataFrameID ];
    
    NSString *conversationID = [NSString testForNull:[frameArray valueForKey:@"conversation_id"]];
    [frame setValue:conversationID forKey:CoreDataFrameConversationID];
    
    NSString *createdAt = [NSString testForNull:[frameArray valueForKey:@"created_at"]];
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
    
    for ( NSUInteger i = 0; i < [messagesArray count]; i++ ) {
       
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

        NSString *userImage = [NSString testForNull:[[messagesArray objectAtIndex:i]  valueForKey:@"user_image_url"]];
        [messages setValue:userImage forKey:CoreDataMessagesUserImage];  
    
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
    
    for ( NSUInteger i = 0; i < [upvoteUsersArray count]; i++ ) {
        
        BOOL voted = [CoreDataUtility checkIfUserUpvotedInFrame:frame];
        
        if ( NO == voted ) {
        
            UpvoteUsers *upvoteUsers  = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityUpvoteUsers inManagedObjectContext:frame.managedObjectContext];
            
            NSString *upvoterID = [NSString testForNull:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"id"]];
            [upvoteUsers setValue:upvoterID forKey:CoreDataUpvoteUserID];
            
            NSString *nickname = [NSString testForNull:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"nickname"]];
            [upvoteUsers setValue:nickname forKey:CoreDataUpvoteUsersNickname];
            
            NSString *rollID = [NSString testForNull:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"public_roll_id"]];
            [upvoteUsers setValue:rollID forKey:CoreDataUpvoteUsersRollID];
            
            NSString *userImage = [NSString testForNull:[[upvoteUsersArray objectAtIndex:i] valueForKey:@"user_image"]];
            [upvoteUsers setValue:userImage forKey:CoreDataUpvoteUsersImage];
            
            [frame addUpvoteUsersObject:upvoteUsers];
            
        }
    
    }

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
        
    NSString *thumbnailURL = [NSString testForNull:[videoArray valueForKey:@"thumbnail_url"]];
    [video setValue:thumbnailURL forKey:CoreDataVideoThumbnailURL];
    
    NSString *title = [NSString testForNull:[videoArray valueForKey:@"title"]];
    [video setValue:title forKey:CoreDataVideoTitle];
    
    if ( [providerName isEqualToString:@"youtube"] ) {

        // sourceURL
        NSString *sourceURL = [NSString testForNull:[videoArray valueForKey:@"source_url"]];
        [video setValue:sourceURL forKey:CoreDataVideoSourceURL];
        
        // provider ID
        NSString *providerID;
        NSScanner *providerIDScanner = [NSScanner scannerWithString:sourceURL];
        [providerIDScanner scanUpToString:@"=" intoString:nil];
        [providerIDScanner scanUpToString:@"&" intoString:&providerID];
        providerID = [providerID stringByReplacingOccurrencesOfString:@"=" withString:@""];
        
        [video setValue:providerID forKey:CoreDataVideoProviderID];
        
    } else if ( [providerName isEqualToString:@"vimeo"] ) {
        
        // Extract vimeo source_url from embed_url
        NSString *embedURL = [NSString testForNull:[videoArray valueForKey:@"embed_url"]];
        
        NSString *sourceURL;
        NSScanner *scanner = [NSScanner scannerWithString:embedURL];
        [scanner scanUpToString:@"http://" intoString:nil];
        [scanner scanUpToString:@"\"" intoString:&sourceURL];
        sourceURL = [sourceURL stringByReplacingOccurrencesOfString:@"=" withString:@""];
        
        // sourceURL
        [video setValue:sourceURL forKey:CoreDataVideoSourceURL];
        
        // provider ID
        NSString *providerID;
        NSScanner *providerIDScanner = [NSScanner scannerWithString:sourceURL];
        [providerIDScanner scanUpToString:@"/video/" intoString:nil];
        [providerIDScanner scanUpToString:@"\"" intoString:&providerID];
        providerID = [providerID stringByReplacingOccurrencesOfString:@"/video/" withString:@""];
        
        [video setValue:providerID forKey:CoreDataVideoProviderID];
        
    } else {
        
        // Do nothing
        
    }
    
    
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