//
//  RollsViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPullToRefreshTableViewController.h"
#import "TableViewManagers.h"
#import "StaticDeclarations.h"

@interface RollsViewController : ASPullToRefreshTableViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) RollsType rollsType;

@end