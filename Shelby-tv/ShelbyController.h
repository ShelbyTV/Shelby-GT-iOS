//
//  ShelbyNavigationControllerViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDeclarations.h"

@interface ShelbyController : UIViewController

- (id)initWithViewControllers:(NSMutableDictionary*)dictionary;
- (void)presentSection:(GuideType)type;

@end