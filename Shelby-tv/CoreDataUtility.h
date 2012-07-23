//
//  CoreDataUtility.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CoreDataUtility : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign, nonatomic) APIRequestType requestType;

#pragma mak - STORE

/** 
 Store JSON-parsed NSDictionary in Core Data for a specific API Request 
 */
+ (void)storeParsedData:(NSDictionary*)parsedDictionary
             inCoreData:(NSManagedObjectContext*)context 
                forType:(APIRequestType)requestType;

#pragma mark - FETCH

/**
 Fetch all Dashboard Entrys
 */

+ (ShelbyUser*)fetchShelbyAuthData;

/**
 Fetch all Dashboard Entrys
 */

+ (NSArray*)fetchAllDashboardEntries;

/**
 Fetch all Explore Rolls
 */

+ (NSArray*)fetchExploreRolls;


/**
 Fetch all Friends Rolls
 */

+ (NSArray*)fetchFriendsRolls;

/**
 Fetch all My Rolls
 */

+ (NSArray*)fetchMyRolls;

/**
 Fetch frames from a specific roll
 */
+ (NSArray*)fetchFramesForRoll:(NSString*)rollID;


/** 
 Fetch Dashboard Entry information stored in Core Data 
 */

+ (DashboardEntry*)fetchDashboardEntryDataForDashboardID:(NSString*)dashboardID;

/**
 Fetch Frame information stored in Core Data
 */

+ (Frame*)fetchFrameWithID:(NSString*)frameID;

/**
 Fetch Roll information stored in Core Data
 */

+ (Roll*)fetchRollWithTitle:(NSString*)title;

/**
 Fetch First Message from dashboardEntry.frame.conversation
 */

+ (Messages*)fetchFirstMessageFromConversation:(Conversation*)conversation;

/**
 Fetch All Messages from frame.conversation
 */

+ (NSArray*)fetchAllMessagesFromConversation:(Conversation*)conversation;

/**
Check if user already voted for a specific frame
*/
+ (BOOL)checkIfUserUpvotedInFrame:(Frame*)frame;

#pragma mark - SAVE

/** 
 Commit unsaved changes for a given NSManagedObjextContext instance 
 */
+ (void)saveContext:(NSManagedObjectContext *)context;

#pragma mark - DELETE

/** 
 Delete all stored information
 */
+ (void)dumpAllData;

/** 
 CoreDataUtility's Singleton Method 
 */
+ (CoreDataUtility*)sharedInstance;

@end