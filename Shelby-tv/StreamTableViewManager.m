//
//  TimelineTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StreamTableViewManager.h"

@implementation StreamTableViewManager

#pragma mark - ASPullToRefreshDelegate Methods
- (void)dataToRefresh
{
    [self.refreshController didFinishRefreshing];
}

@end