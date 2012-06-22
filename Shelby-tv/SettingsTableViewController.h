//
//  SettingsTableViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelbyMenuController.h"

@interface SettingsTableViewController : UITableViewController <ShelbyMenuControllerDelegate>

@property (strong, nonatomic) ShelbyMenuController *shelbyMenuController;

@end