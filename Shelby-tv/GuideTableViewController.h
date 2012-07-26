//
//  GuideTableViewController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ASPullToRefreshTableViewController.h"
#import "AppDelegate.h"

@interface GuideTableViewController : ASPullToRefreshTableViewController <ShelbyMenuDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) AppDelegate *appDelegate;

// For most GuideTableViewManagers
- (id)initWithType:(GuideType)type;

// For RollFramesTableViewManager
- (id)initWithType:(GuideType)type navigationController:(UINavigationController*)navigationController andRollID:(NSString*)rollID;


@end