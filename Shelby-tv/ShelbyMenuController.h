//
//  ShelbyNavigationControllerViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDeclarations.h"
#import "ShelbyMenuView.h"

@protocol ShelbyMenuControllerDelegate <NSObject>

- (void)browseRollsButton;
- (void)myRollsButton;
- (void)peopleRollsButton;
- (void)settingsButton;
- (void)streamButton;

@end

@interface ShelbyMenuController : UIViewController <ShelbyMenuControllerDelegate>

@property (strong, nonatomic) ShelbyMenuView *menuView;

- (id)initWithViewControllers:(NSMutableDictionary*)dictionary;
- (void)presentSection:(GuideType)type;

@end