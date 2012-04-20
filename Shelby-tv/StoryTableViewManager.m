//
//  StoryTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "StoryTableViewManager.h"

@implementation StoryTableViewManager
@synthesize refreshController = _refreshController;

#pragma mark - UITableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - UITableViewDatasource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - ASPullToRefreshScrollDelegate Methods
- (void)refreshScrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    [self.refreshController scrollViewWillBeginDragging:scrollView];
}

- (void)refreshScrollViewDidScroll:(UIScrollView*)scrollView
{
    [self.refreshController scrollViewDidScroll:scrollView];
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshController scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    [self refreshScrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    [self refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    [self refreshScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end