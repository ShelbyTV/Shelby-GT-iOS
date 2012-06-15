//
//  AppDelegate.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAppearanceContainer>

@property (strong, nonatomic) UIWindow *window;

- (void)presentLoginViewController;

@end