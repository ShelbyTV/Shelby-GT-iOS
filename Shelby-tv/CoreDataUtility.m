//
//  CoreDataUtility.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CoreDataUtility.h"

@interface CoreDataUtility ()

@end

@implementation CoreDataUtility


#pragma mark - Public Methods
+ (void)saveContext:(NSManagedObjectContext *)context
{

        
    NSError *error = nil;
    
    if ( context ) {
        
        if ( [context hasChanges] && ![context save:&error] ) {
         
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
        }
        
    }


}

@end