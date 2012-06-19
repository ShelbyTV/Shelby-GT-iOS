//
//  GuideMenuView.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/12/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyMenuView.h"

@implementation ShelbyMenuView

@synthesize browseRollsButton = _browseRollsButton;
@synthesize myRollsButton = _myRollsButton;
@synthesize peopleRollsButton = _peopleRollsButton;
@synthesize settingsButton = _settingsButton;
@synthesize streamButton = _streamButton;

- (void)dealloc
{
    self.browseRollsButton = nil;
    self.myRollsButton = nil;
    self.peopleRollsButton = nil;
    self.settingsButton = nil;
    self.streamButton = nil;
}

@end