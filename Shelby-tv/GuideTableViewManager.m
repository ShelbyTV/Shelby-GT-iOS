//
//  GuideTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GuideTableViewManager.h"

@implementation GuideTableViewManager
@synthesize refreshController = _refreshController;
@synthesize navigationController = _navigationController;
@synthesize parsedDictionary = _parsedDictionary;

#pragma mark - GuideTableViewManagerDelegate methods
- (void)performAPIRequest
{
    // Do nothing in GuideTableViewManager
}

- (void)dataReturnedFromAPI:(NSNotification *)notification
{
    // Do nothing in GuideTableViewManager
}

#pragma mark - UITableViewDatasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    [self.refreshController scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    [self.refreshController scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    [self.refreshController scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end