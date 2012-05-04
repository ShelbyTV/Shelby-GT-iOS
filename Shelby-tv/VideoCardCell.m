//
//  VideoCardCell.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/4/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"

@implementation VideoCardCell
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize captionView = _captionView;
@synthesize commentView = _commentView;

- (void)dealloc
{
    self.thumbnailImageView = nil;
    self.captionView = nil;
    self.captionView = nil;
}

@end