//
//  RollsCell.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/23/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "RollsCell.h"

@implementation RollsCell
@synthesize coverImageView = _coverImageView;
@synthesize creatorNameLabel = _creatorNameLabel;
@synthesize rollNameLabel = _rollNameLabel;
@synthesize frameCountLabel = _frameCountLabel;
@synthesize followingCountLabel = _followingCountLabel;

- (void)dealloc
{
    
    self.coverImageView = nil;
    self.creatorNameLabel = nil;
    self.rollNameLabel = nil;
    self.frameCountLabel = nil;
    self.followingCountLabel = nil;
    
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Customize Labels (all other label customization in VideCardCell.xib)
    [self.creatorNameLabel setFont:[UIFont fontWithName:@"Ubuntu" size:self.creatorNameLabel.font.pointSize]];
    [self.rollNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.rollNameLabel.font.pointSize]];
    [self.frameCountLabel setFont:[UIFont fontWithName:@"Ubuntu" size:self.frameCountLabel.font.pointSize]];
    [self.followingCountLabel setFont:[UIFont fontWithName:@"Ubuntu" size:self.followingCountLabel.font.pointSize]];
    
}

@end