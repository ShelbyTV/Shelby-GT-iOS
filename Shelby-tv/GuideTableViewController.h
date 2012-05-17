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
#import "UINavigationItem+CustomTitleView.h"

// Other
#import "StaticDeclarations.h"

@interface GuideTableViewController : ASPullToRefreshTableViewController

- (id)initWithGuideType:(GuideType)type andTableViewManager:(GuideTableViewManager*)manager;

@end