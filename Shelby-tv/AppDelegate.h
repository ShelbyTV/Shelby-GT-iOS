//
//  AppDelegate.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAppearanceContainer>
{
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;     
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

@end