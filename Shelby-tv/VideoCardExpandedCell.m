//
//  VideoCardExpandedCell.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/22/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardExpandedCell.h"
#import "StaticDeclarations.h"
#import <CoreGraphics/CoreGraphics.h>

@interface VideoCardExpandedCell ()

@end

@implementation VideoCardExpandedCell
@synthesize originNetworkImageView = _originNetworkImageView;
@synthesize userImageView = _userImageView;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize upvoteButton = _upvoteButton;
@synthesize commentButton = _commentButton;
@synthesize rollButton = _rollButton;
@synthesize shareButton = _shareButton;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize rollLabel = _rollLabel;
@synthesize createdAtLabel = _createdAtLabel;
@synthesize upvotedUserZero = _upvotedUserZero;
@synthesize upvotedUserOne = _upvotedUserOne;
@synthesize upvotedUserTwo = _upvotedUserTwo;
@synthesize upvotedUserThree = _upvotedUserThree;
@synthesize upvotedUserFour = _upvotedUserFour;
@synthesize upvotedUserFive = _upvotedUserFive;
@synthesize upvotedUserSix = _upvotedUserSix;
@synthesize upvotedUserSeven = _upvotedUserSeven;
@synthesize upvotedUserEight = _upvotedUserEight;
@synthesize upvotedUserNine = _upvotedUserNine;

#pragma mark - Memory Deallocation Methods
- (void)dealloc
{
    self.userImageView = nil;
    self.originNetworkImageView = nil;
    self.thumbnailImageView = nil;
    self.upvoteButton = nil;
    self.commentButton = nil;
    self.rollButton = nil;
    self.shareButton = nil;
    self.nicknameLabel = nil;
    self.rollLabel = nil;
    self.createdAtLabel = nil;
    self.upvotedUserZero = nil;
    self.upvotedUserOne = nil;
    self.upvotedUserTwo = nil;
    self.upvotedUserThree = nil;
    self.upvotedUserFour = nil;
    self.upvotedUserFive = nil;
    self.upvotedUserSix = nil;
    self.upvotedUserSeven = nil;
    self.upvotedUserEight = nil;
    self.upvotedUserNine = nil;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ColorConstants_BackgroundColor;
    
    // Customize Labels (all other label customization in VideCardCell.xib)
    [self.upvoteButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:16.0f]];
    [self.commentButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:16.0f]];
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:15.0f]];
    [self.rollLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:10.0f]];
    [self.createdAtLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:10.0f]];
    
}
@end
