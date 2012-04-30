//
//  StoryTableViewManager.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "ASPullToRefreshTableViewController.h"

@interface StoryTableViewManager : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ASPullToRefreshTableViewController *refreshController;

@end