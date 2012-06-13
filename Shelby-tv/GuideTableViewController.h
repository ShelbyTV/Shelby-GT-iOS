//
//  GuideTableViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

// Controllers
#import "ASPullToRefreshTableViewController.h"
#import "TableViewManagers.h"

// Views
#import "ShelbyMenuView.h"

// Other
#import "StaticDeclarations.h"

@interface GuideTableViewController : ASPullToRefreshTableViewController

@property (weak, nonatomic) IBOutlet ShelbyMenuView *shelbyNavigationView;

- (id)initWithType:(GuideType)type forTableViewManager:(GuideTableViewManager*)manager withPullToRefreshEnabled:(BOOL)refreshEnabled;

@end