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
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize favoriteButton = _favoriteButton;
@synthesize commentsButton = _commentsButton;
@synthesize rollButton = _rollButton;
@synthesize shareButton = _shareButton;
@synthesize favoriteLabel = _favoriteLabel;
@synthesize commentsLabel = _commentsLabell;

#pragma mark - Memory Deallocation Methods
- (void)dealloc
{
    self.thumbnailImageView = nil;
    self.favoriteButton = nil;
    self.commentsButton = nil;
    self.rollButton = nil;
    self.shareButton = nil;
    self.favoriteLabel = nil;
    self.commentsLabel = nil;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Customize Labels (all other label customization in VideCardCell.xib)
    self.favoriteLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:17.0f];
    self.commentsLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:17.0f];
}

@end