//
//  ShelbyMenuController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/12/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShelbyMenuController : NSObject

@property (strong, nonatomic) UIViewController *rootViewController;

- (IBAction)browseRollsButton;
- (IBAction)myRollsButton;
- (IBAction)peopleRollsButton;
- (IBAction)streamButton;
- (IBAction)settingsButton;

@end
