//
//  SettingsTableViewController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyMenuViewController.h"

@interface SettingsTableViewController : UITableViewController <ShelbyMenuDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;

@end
