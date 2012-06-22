//
//  VideoCardCell.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/4/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"
#import "StaticDeclarations.h"
#import <CoreGraphics/CoreGraphics.h>

@interface VideoCardCell ()

@end

@implementation VideoCardCell
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
@synthesize commentLabel = _commentLabel;

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
    self.commentLabel = nil;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ColorConstants_BackgroundColor;
    
    // Customize Labels (all other label customization in VideCardCell.xib)
    [self.upvoteButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:16.0f]];
    
    self.nicknameLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:15.0f];
    self.rollLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:10.0f];
    self.createdAtLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:10.0f];
    
    self.commentLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:16.0f];
}

@end