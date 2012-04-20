//
//  TimelineTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "TimelineTableViewManager.h"

@implementation TimelineTableViewManager

#pragma mark - ASPullToRefreshDelegate Methods
- (void)dataToRefresh
{
    [self.refreshController didFinishRefreshing];
}

@end