//
//  SettingsTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/12/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "SettingsTableViewManager.h"

@implementation SettingsTableViewManager

#pragma mark - GuideTableViewMangerDelegate Methods
- (void)loadDataOnInitializationForTableView:(UITableView*)tableView
{
    self.tableView = tableView;
    [self.tableView reloadData];
}

- (void)loadDataFromCoreData
{
    
}

- (void)performAPIRequest
{
    
}

- (void)dataReturnedFromAPI:(NSNotification*)notification
{
    
}

@end
