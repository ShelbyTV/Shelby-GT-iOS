//
//  CoreDataUtility.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CoreDataUtility.h"

@interface CoreDataUtility ()
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic) NSString *persistentStorePath;

@end

@implementation CoreDataUtility
@synthesize context = _context;
@synthesize coordinator = _coordinator;
@synthesize persistentStorePath = _persistentStorePath;

static CoreDataUtility *sharedInstance = nil;

#pragma mark - Singleton Methods
+ (CoreDataUtility*)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)init
{
    
    if ( self = [super init] ) {
     
        [self context]; // Initalize NSManagedObjectContext
        
    }
    
    return self;
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
+ (void)saveContext:(NSManagedObjectContext *)context
{

    NSError *error = nil;
    
    if ( ![context save:&error] ) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

}

#pragma mark - Custom Getter Methods
- (NSManagedObjectContext*)context
{
    
    if ( ![self context] ) {
    
        self.context = [[NSManagedObjectContext alloc] init];
        self.context.persistentStoreCoordinator = self.coordinator;

    }
    
    return self.context;

}

- (NSPersistentStoreCoordinator*)coordinator
{
    
    if ( ![self coordinator] ) {
        
        NSURL *storeURL = [NSURL fileURLWithPath:self.persistentStorePath];
        self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        NSError *error = nil;
        NSPersistentStore *persistentStore = [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert3( persistentStore != nil, @"Unhandled error adding persistent store in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
   
    }
    
    return self.coordinator;
    
}

- (NSString *)persistentStorePath {
    
    if ( ![self persistentStorePath] ) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths lastObject];
        self.persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"Shelby.sqlite"];
        
    }
    return self.persistentStorePath;
}

@end