//
//  VideoCardCell.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/4/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"

@interface VideoCardCell ()

@end

@implementation VideoCardCell
@synthesize shelbyFrame = _shelbyFrame;
@synthesize originNetworkImageView = _originNetworkImageView;
@synthesize userImageView = _userImageView;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize upvoteButton = _upvoteButton;
@synthesize commentButton = _commentButton;
@synthesize rollButton = _rollButton;
@synthesize shareButton = _shareButton;
@synthesize videoTitleLabel = _videoTitleLabel;
@synthesize rollLabel = _rollLabel;
@synthesize createdAtLabel = _createdAtLabel;

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
    self.videoTitleLabel = nil;
    self.rollLabel = nil;
    self.createdAtLabel = nil;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ColorConstants_BackgroundColor;

    // Customize Labels (all other label customization in VideCardCell.xib)
    [self.upvoteButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:16.0f]];
    [self.commentButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:16.0f]];
    [self.videoTitleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoTitleLabel.font.pointSize]];
    [self.rollLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.rollLabel.font.pointSize]];
    [self.createdAtLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.createdAtLabel.font.pointSize]];

}

@end