//
//  ShelbyNavigationControllerViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDeclarations.h"

@protocol ShelbyMenuControllerDelegate <NSObject>

- (IBAction)browseRollsButton:(id)sender;
- (IBAction)myRollsButton:(id)sender;
- (IBAction)peopleRollsButton:(id)sender;
- (IBAction)settingsButton:(id)sender;
- (IBAction)streamButton:(id)sender;

@end

@interface ShelbyMenuController : UIViewController <ShelbyMenuControllerDelegate>

- (id)initWithViewControllers:(NSMutableDictionary*)dictionary;

@end