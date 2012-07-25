//
//  AppDelegate.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 4/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "MBProgressHUD.h"
#import "ShelbyMenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAppearanceContainer>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) ShelbyMenuViewController *menuController;

- (void)presentLoginViewController;
- (void)addHUDWithMessage:(NSString*)message;
- (void)removeHUD;

@end