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
#import "ShelbyMenuController.h"

@interface GuideTableViewController : ASPullToRefreshTableViewController <ShelbyControllerDelegate>

@property (strong, nonatomic) ShelbyMenuController *shelbyController;

- (id)initWithType:(GuideType)type;

@end