//
//  CoreDataUtility.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataUtility : NSObject

+ (void)saveContext:(NSManagedObjectContext*)context;

@end