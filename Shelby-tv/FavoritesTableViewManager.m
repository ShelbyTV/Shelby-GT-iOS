//
//  FavoritesTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "FavoritesTableViewManager.h"

@implementation FavoritesTableViewManager

#pragma mark - ASPullToRefreshDelegate Methods
- (void)dataToRefresh
{
    [self.refreshController didFinishRefreshing];
}

@end