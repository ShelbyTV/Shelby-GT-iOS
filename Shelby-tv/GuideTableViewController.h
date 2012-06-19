//
//  GuideTableViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPullToRefreshTableViewController.h"
#import "ShelbyController.h"
#import "StaticDeclarations.h"

@interface GuideTableViewController : ASPullToRefreshTableViewController

@property (strong, nonatomic) ShelbyController *shelbyController;

- (id)initWithType:(GuideType)type;

@end