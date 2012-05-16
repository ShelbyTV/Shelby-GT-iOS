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

/** Store JSON-parsed NSDictionary in Core Data for a specific API Request */
+ (void)storeParsedData:(NSDictionary*)parsedDictionary
             inCoreData:(NSManagedObjectContext*)context 
                ForType:(APIRequestType)requestType;

/** Fetch information stored in Core Data */
+ (void)fetchData:(NSManagedObjectContext*)context OfType:(APIRequestType)requestType;
                

/** Commit unsaved changes for a given NSManagedObjextContext instance */
+ (void)saveContext:(NSManagedObjectContext*)context;

/** CoreDataUtility's Singleton Method */
+ (CoreDataUtility*)sharedInstance;

@end