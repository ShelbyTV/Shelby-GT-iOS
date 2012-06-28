//
//  CoreDataUtility.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "StaticDeclarations.h"

@interface CoreDataUtility : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign, nonatomic) APIRequestType requestType;

/** 
 Store JSON-parsed NSDictionary in Core Data for a specific API Request 
 */
+ (void)storeParsedData:(NSDictionary*)parsedDictionary
             inCoreData:(NSManagedObjectContext*)context 
                forType:(APIRequestType)requestType;


/**
 Fetch all Dashboard Entrys
 */

+ (ShelbyUser*)fetchShelbyAuthData;

/**
 Fetch all Dashboard Entrys
 */

+ (NSArray*)fetchAllDashboardEntries;

/**
 Fetch all Browse Rolls
 */

+ (NSArray*)fetchBrowseRolls;

/**
 Fetch all My Rolls
 */

+ (NSArray*)fetchMyRolls;

/**
 Fetch all People Rolls
 */

+ (NSArray*)fetchPeopleRolls;

/**
 Fetch videos from a specific roll
 */

+ (NSArray*)fetchRollVideos;

/** 
 Fetch Dashboard Entry information stored in Core Data 
 */

+ (DashboardEntry*)fetchDashboardEntryDataForRow:(NSUInteger)row;

/**
 Fetch First Message from dashboardEntry.frame.conversation
 */

+ (Messages*)fetchFirstMessageFromConversation:(Conversation*)conversation;

/**
Check if user already voted for a specific frame
*/
+ (BOOL)checkIfUserUpvotedInFrame:(Frame*)frame;

/** 
 Commit unsaved changes for a given NSManagedObjextContext instance 
 */
+ (void)saveContext:(NSManagedObjectContext *)context;

/** 
 Delete all stored information
 */
+ (void)dumpAllData;


/** 
 CoreDataUtility's Singleton Method 
 */
+ (CoreDataUtility*)sharedInstance;

@end