//
//  ExistingRollCell.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/18/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ExistingRollCell.h"
#import "StaticDeclarations.h"

@implementation ExistingRollCell
@synthesize button = _button;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize privacyLabel = _privacyLabel;
@synthesize userImageView = _userImageView;
@synthesize lockImageView = _lockImageView;

- (void)dealloc
{
    self.button = nil;
    self.nicknameLabel = nil;
    self.privacyLabel = nil;
    self.userImageView = nil;
    self.lockImageView = nil;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ColorConstants_BackgroundColor;
    
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.nicknameLabel.font.pointSize]];
    [self.nicknameLabel setTextColor:ColorConstants_GrayTextColor];
    
    [self.privacyLabel setFont:[UIFont fontWithName:@"Ubuntu" size:self.privacyLabel.font.pointSize]];
    [self.privacyLabel setTextColor:[UIColor whiteColor]];
    
}

@end