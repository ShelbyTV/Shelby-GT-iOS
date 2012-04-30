//
//  StoryViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPullToRefreshTableViewController.h"
#import "TableViewManagers.h"
#import "Constants.h"

// Structure that delineates between instances of StoryTableViewController;
typedef enum _StoryType
{
    StoryTypeStream= 0,
    StoryTypeRolls,
    StoryTypeSave,
    StoryTypeSearch
    
} StoryType;;

@interface StoryViewController : ASPullToRefreshTableViewController

- (id)initWithType:(StoryType)type andTableViewManager:(StoryTableViewManager*)manager;

@end