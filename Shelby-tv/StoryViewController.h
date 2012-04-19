//
//  StoryViewController.h
//  Shelby-tv
//
//  Created by Arthur on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPullToRefreshTableViewController.h"

// Structure that delineates between instances of StoryTableViewController;
typedef enum _StoryType
{
    StoryTypeTimeline = 0,
    StoryTypeFavorites,
    StoryTypeWatchLater,
    StoryTypeSearch
    
} StoryType;;

@interface StoryViewController : ASPullToRefreshTableViewController

@property (assign, nonatomic) StoryType storyType;

@end