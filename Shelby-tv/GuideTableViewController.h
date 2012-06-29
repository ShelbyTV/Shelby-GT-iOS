//
//  GuideTableViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPullToRefreshTableViewController.h"
#import "StaticDeclarations.h"
#import "ShelbyMenuViewController.h"

@interface GuideTableViewController : ASPullToRefreshTableViewController <ShelbyMenuDelegate>

@property (strong, nonatomic) ShelbyMenuViewController *menuController;
@property (strong, nonatomic) UINavigationController *navigationController;

// For most GuideTableViewManagers
- (id)initWithType:(GuideType)type;

// For RollFramesTableViewManager
- (id)initWithType:(GuideType)type andRollID:(NSString*)rollID;


@end