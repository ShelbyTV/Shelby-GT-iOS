//
//  ShelbyNavigationControllerViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDeclarations.h"

@protocol ShelbyMenuDelegate <NSObject>

- (void)browseRollsButtonAction;
- (void)myRollsButtonAction;
- (void)peopleRollsButtonAction;
- (void)settingsButtonAction;
- (void)streamButtonAction;

@end

@interface ShelbyMenuViewController : UIViewController <ShelbyMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *browseRollsButton;
@property (weak, nonatomic) IBOutlet UIButton *myRollsButton;
@property (weak, nonatomic) IBOutlet UIButton *peopleRollsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *streamButton;

- (id)initWithViewControllers:(NSMutableDictionary*)dictionary;
- (void)presentSection:(GuideType)type;

@end