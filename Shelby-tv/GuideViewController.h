//
//  StoryViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPullToRefreshTableViewController.h"
#import "TableViewManagers.h"
#import "StaticDeclarations.h"

@interface GuideViewController : ASPullToRefreshTableViewController

- (id)initWithGuideType:(GuideType)type andTableViewManager:(GuideTableViewManager*)manager;

@end