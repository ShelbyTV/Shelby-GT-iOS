//
//  VideoCardCell.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/4/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"
#import <CoreGraphics/CoreGraphics.h>

@interface VideoCardCell ()

@end

@implementation VideoCardCell
@synthesize originNetworkImageView = _originNetworkImageView;
@synthesize userImageView = _userImageView;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize favoriteButton = _favoriteButton;
@synthesize commentsButton = _commentsButton;
@synthesize rollButton = _rollButton;
@synthesize shareButton = _shareButton;
@synthesize favoriteLabel = _favoriteLabel;
@synthesize commentsLabel = _commentsLabell;
@synthesize nicknameLabel = _nicknameLabel;

#pragma mark - Memory Deallocation Methods
- (void)dealloc
{
    self.userImageView = nil;
    self.originNetworkImageView = nil;
    self.thumbnailImageView = nil;
    self.favoriteButton = nil;
    self.commentsButton = nil;
    self.rollButton = nil;
    self.shareButton = nil;
    self.favoriteLabel = nil;
    self.commentsLabel = nil;
    self.nicknameLabel = nil;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Customize Labels (all other label customization in VideCardCell.xib)
    self.nicknameLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:19.0f];
    self.favoriteLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:16.0f];
    self.commentsLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:16.0f];
}

@end