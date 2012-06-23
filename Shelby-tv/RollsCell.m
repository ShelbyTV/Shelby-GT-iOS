//
//  RollsCell.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/23/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "RollsCell.h"

@implementation RollsCell
@synthesize rollsCoverImageView = _rollsCoverImageView;
@synthesize creatorNameLabel = _creatorNameLabel;
@synthesize rollsNameLabel = _rollsNameLabel;
@synthesize videoCountLabel = _videoCountLabel;
@synthesize watchingLabel = _watchingLabel;

- (void)dealloc
{
    
    self.rollsCoverImageView = nil;
    self.creatorNameLabel = nil;
    self.rollsNameLabel = nil;
    self.videoCountLabel = nil;
    self.watchingLabel = nil;
    
}

@end