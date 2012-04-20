//
//  StoryTableViewManager.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPullToRefreshTableViewController.h"

@interface StoryTableViewManager : NSObject <UITableViewDataSource, UITableViewDelegate, ASPullToRefreshScrollDelegate>

@property (strong, nonatomic) ASPullToRefreshTableViewController *refreshController;

@end