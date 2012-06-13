//
//  ShelbyMenuController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/12/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyMenuController.h"
#import "GuideTableViewController.h"
#import "TableViewManagers.h"

@interface ShelbyMenuController ()

@end

@implementation ShelbyMenuController
@synthesize rootViewController = _rootViewController;

- (id)init
{
    if ( self = [super init] ) {
        
        /// *** STREAM *** ///
        StreamTableViewManager *streamTableViewManager = [[StreamTableViewManager alloc] init];
        
        GuideTableViewController *streamViewController = [[GuideTableViewController alloc] initWithType:GuideType_Stream 
                                                                                    forTableViewManager:streamTableViewManager 
                                                                               withPullToRefreshEnabled:YES];
        UINavigationController *streamNavigationController = [[UINavigationController alloc] initWithRootViewController:streamViewController];
        
        streamTableViewManager.navigationController = streamNavigationController;
        
        // Set Application's rootViewController (to be passed to UIWindow's rootViewController property)
        self.rootViewController = streamNavigationController;
        
    }
    
    return self;
}

@end
