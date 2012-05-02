//
//  RollsViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPullToRefreshTableViewController.h"
#import "StaticDeclarations.h"

@interface RollsTableViewController : UIViewController 

@property (strong, nonatomic) UINavigationController *navigationController;

- (id)initWithRollsType:(RollsType)type;

@end